#!/bin/sh

if [ $# -ne 2 ]; then
  echo Run this in the kde expressions directory
  echo usage: $0 oldversion newversion
  echo example: $0 4.3.4 4.3.5
  echo
  echo This will not update the l10n expressions, which have their own generator.
  echo This code supposes that the sha* assignations happen in the immediately next
  echo line to the url assignation.
  exit 1
fi

OLD=$1
NEW=$2


# Regexp to match for the old version
regexp_old="$(echo $OLD | sed -e 's/\./\\./g')"


# stdin: the result of grep -1 "\<url" $filename
# $1: the filename grepped, because this will modify it.
function updateinfile() {
  local newhash oldhash
  local file=$1
  echo File: $file
  while read line; do
    if echo "$line" | grep -q -e "$regexp_old"; then
      url=$(echo "$line" | sed 's/.*\<url *= *"\?\(.*\)"\?.*;.*/\1/')
      echo - Url: "$url"
      newurl=$(echo $url | sed s/"$regexp_old"/$NEW/g)
      echo - New Url: "$newurl"
      newhash=$(nix-prefetch-url "$newurl")
      if [ $? -ne 0 ]; then
         echo Error downloading
         exit 1;
      fi
      echo - New Hash: "$newhash"
    elif echo "$line" | grep -q -e '\<sha[0-9]\+ *='; then
      oldhash=$(echo "$line" | sed 's/.*"\(.*\)".*/\1/')
      echo - Oldhash: $oldhash
      # Update the old hash in the file for the new hash
      sed -i 's/\(.*\)sha.*'$oldhash'.*/\1sha256 = "'$newhash'";/g' $file
    fi
  done
  sed -i s/"$regexp_old"/$NEW/g $file
}


# stdin: the nix files, which have 'fetchurl' calls downloading the old version files
function updatefiles() {
  while read A; do
    # If the file has the old version in it...
    if grep -q -e "$regexp_old" $A; then

      # Pass the url parameters and the surrounding shaXXX = expression to updateinfile
      grep -1 "\<url\>" $A > tmp;
      < tmp updateinfile $A
    fi
  done
}

# Apply the version update to all nix files but l10n from '.'
find . -\( -name *.nix -and -not -path "*l10n*" -\) | updatefiles
