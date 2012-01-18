buildInputs="$unzip"
source $stdenv/setup

unzip $src || true

mkdir -p $out
mv $dirname/* $out/

# Remove crap in the root directory.
for file in $out/*
do
  if test -f $file ; then
    rm $file
  fi
done

# Set the dynamic linker.
rpath=
for i in $libraries; do
    rpath=$rpath${rpath:+:}$i/lib
done
find $out -type f -perm +100 \
    -exec patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
    --set-rpath "$rpath" {} \;

# Unpack .pack files.
for i in $(find $out -name "*.pack"); do
    echo "unpacking $i..."
    $out/bin/unpack200 "$i" "$(dirname $i)/$(basename $i .pack).jar"
    rm "$i"
done

# Put the *_md.h files in the right place.
cd $out/include && ln -s */*_md.h .
