source $stdenv/setup

unzip $src || true

ensureDir $out

echo "Moving sources to the right location"
mv $version/* $out/

echo "Removing files at top level"
for file in $out/*
do
  if test -f $file ; then
    rm $file
  fi
done
rm -rf $out/docs

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
