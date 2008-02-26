source $stdenv/setup

echo "Unpacking distribution"
unzip ${src} || true

# set the dynamic linker of unpack200, necessary for construct script
echo "patching unpack200"
patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" --set-rpath "" */bin/unpack200 || fail

echo "constructing JDK and JRE installations"
if test -z "$installjdk"; then
  sh ${construct} . tmp-linux-jdk tmp-linux-jre
  ensureDir $out
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
  rpath=$rpath${rpath:+:}$out/lib/$architecture/jli
else
  rpath=$rpath${rpath:+:}$out/jre/lib/$architecture/jli
fi

# set all the dynamic linkers
find $out -type f -perm +100 \
    -exec patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
    --set-rpath "$rpath" {} \;

function mozillaExtraLibPath() {
  p=$1
  if test -e "$p"; then
    echo "$libstdcpp5/lib" > $p/extra-library-path
  fi
}

if test -z "$pluginSupport"; then
  rm $out/bin/javaws
else
  source $makeWrapper

  mv $out/bin/javaws $out/bin/javaws.bin
  makeWrapper "$out/bin/javaws.bin" "$out/bin/javaws" \
    --suffix-each LD_LIBRARY_PATH ':' "$(addSuffix /lib $libPath)"

  mozillaExtraLibPath "$out/jre/plugin/i386/ns7"
  mozillaExtraLibPath "$out/plugin/i386/ns7"
fi

# Workaround for assertions in xlib, see http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6532373.
substituteInPlace $out/jre/lib/i386/xawt/libmawt.so --replace XINERAMA FAKEEXTN
