source $stdenv/setup

echo "Unpacking distribution"
unzip ${src} || true

# set the dynamic linker of unpack200, necessary for construct script
echo "patching unpack200"
patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" --set-rpath "" */bin/unpack200

echo "constructing JDK and JRE installations"
if test -z "$installjdk"; then
  sh ${construct} . tmp-linux-jdk tmp-linux-jre
  mkdir -p $out
  cp -R tmp-linux-jre/* $out
else
  sh ${construct} . $out tmp-linux-jre
fi

echo "removing files at top level of installation"
for file in $out/*
do
  if test -f $file ; then
    rm $file
  fi
done
rm -rf $out/docs

# construct the rpath
rpath=
for i in $libraries; do
    rpath=$rpath${rpath:+:}$i/lib
done

if test -z "$installjdk"; then
  jrePath=$out
else
  jrePath=$out/jre
fi

if test -n "$jce"; then
  unzip $jce
  cp -v jce/*.jar $jrePath/lib/security
fi

rpath=$rpath${rpath:+:}$jrePath/lib/$architecture/jli

# set all the dynamic linkers
find $out -type f -perm +100 \
    -exec patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
    --set-rpath "$rpath" {} \;

find $out -name "*.so" -exec patchelf --set-rpath "$rpath" {} \;

if test -z "$pluginSupport"; then
    rm -f $out/bin/javaws
fi

mkdir $jrePath/lib/$architecture/plugins
ln -s $jrePath/lib/$architecture/libnpjp2.so $jrePath/lib/$architecture/plugins

