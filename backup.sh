#!/bin/bash

bool=true

source $(dirname $(readlink -f $0))/core.sh

help() {
	phelp $0	
}

restore=false
archive=
directories=()

while test "$#" -gt 0; do
	case "$1" in
		-r|--restore)
			restore=false
			shift
			;;
		*)
			# If the backup location has not been set,
			if [[ -z "$archive" ]]; then
				# That takes priority
				archive="$1"
			else
				# Else, add the directory to the list
				directories+=("$1")
			fi

			shift
			;;
	esac
done

if [ -z "$archive" ]; then
	perror "Please specify a backup location"
	exit 1
fi

if [ ${#directories[@]} -eq 0 ]; then
	# directories to back up is empty. Use defaults.
	home=$(echo ~)
	directories=("/opt/scripts" "/etc/apache2/sites-available" "/var/www" "$home/.config" "/opt/android-studio" "$home/projects")
fi

file_list=

if [[ "$restore" == "false" ]]; then
	# Backing up, not restoring
	for dir in "${directories[@]}"; do
		if [[ ! -d "$dir" ]]; then
			echo "Warning: Skipping $dir (does not exist or is not a directory)"
		fi

		# Directory exists, add it to the file list
		file_list="$file_list $(readlink -f "$dir")"
	done
	time tar -cjf "$archive" $file_list # Purposefully don't put $file_list in quotes in order for tar to treat it as multiple args
	du -b "$archive" -h
else
	#for dir in "$backup_location"; do
		# Make sure it's a directory
	#	if [[ -d "$dir" ]]; then
			
	#	fi
	#done
	exit 0
fi
