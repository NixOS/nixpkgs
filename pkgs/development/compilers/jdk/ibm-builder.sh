source $stdenv/setup

if ! test -e "$pathname"; then
    echo ""
    echo "SORRY!"
    echo "You should download \`$(basename $pathname)' from IBM and place it in $(dirname $pathname)."
    echo "Blame IBM, not us."
    echo ""
    exit 1
fi

actual=$(md5sum -b $pathname | cut -c1-32)
if test "$actual" != "$md5"; then
    echo "hash is $actual, expected $md5"
    exit 1
fi

tar zxf $pathname || true

ensureDir $out
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
glibc=$(cat $NIX_GCC/nix-support/orig-glibc)
find $out -type f -perm +100 \
    -exec patchelf --interpreter $glibc/lib/ld-linux.so.* \
    --set-rpath "$rpath" {} \;
