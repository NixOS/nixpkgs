source $stdenv/setup

mkdir unzipped
pushd unzipped
unzip $src || true
popd

ensureDir $out
mv unzipped/* $out/

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
    -exec patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" {} \;
find $out -type f -perm +100 \
    -exec patchelf --set-rpath "$rpath" {} \;
