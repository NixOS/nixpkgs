set -e

. $stdenv/setup

cp $src .
bin=`basename $src`
chmod u+x $bin

# This is required because those GNU coreutils fuckers suddenly
# removed the `+N' syntax (due to a misguided desire for "standards
# compliance"), which the Blackdown installer uses.
export _POSIX2_VERSION=199209

alias more=cat
yes yes | ./$bin

mkdir $out
mv $dirname/* $out/

# remove crap in the root directory
for file in $out/*
do
  if test -f $file ; then
    rm $file
  fi
done
