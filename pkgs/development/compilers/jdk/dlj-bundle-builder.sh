source $stdenv/setup

echo "Unpacking distribution"
unzip ${src} || true

echo "Constructing JDK and JRE"
if test -z "$installjdk"; then
  sh ${construct} . tmp-linux-jdk tmp-linux-jre
  ensureDir $out
  cp -R tmp-linux-jre/* $out
else
  sh ${construct} . $out tmp-linux-jre
fi

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

if test -z "$installjdk"; then
  rpath=$rpath${rpath:+:}$out/lib/i386/jli
else
  rpath=$rpath${rpath:+:}$out/jre/lib/i386/jli
fi

find $out -type f -perm +100 \
    -exec patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
    --set-rpath "$rpath" {} \;
