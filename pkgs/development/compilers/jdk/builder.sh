buildInputs="$unzip"
source $stdenv/setup

src=$filename.bin

if ! test -e "$pathname"; then
    echo ""
    echo "SORRY!"
    echo "You should download \`$(basename $pathname)' from Sun and place it in $(dirname $pathname)."
    echo "Blame Sun, not us."
    echo "If you are doing a chroot build - try a non-chroot build, because we need to access /tmp."
    echo ""
    exit 1
fi

actual=$(md5sum -b $pathname | cut -c1-32)
if test "$actual" != "$md5"; then
    echo "hash is $actual, expected $md5"
    exit 1
fi

unzip $pathname || true

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
