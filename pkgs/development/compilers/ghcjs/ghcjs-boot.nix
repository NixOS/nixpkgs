{ runCommand, src }:

# we remove the patches so ghcjs-boot doesn't try to apply them again.
runCommand "${src.name}-patched" {} ''
  cp -r ${src} $out
  chmod -R +w $out

  # Make the patches be relative their corresponding package's directory.
  # See: https://github.com/ghcjs/ghcjs-boot/pull/12
  for patch in $out/patches/*.patch; do
    echo ">> fixing patch: $patch"
    sed -i -e 's@ \(a\|b\)/boot/[^/]\+@ \1@g' $patch
  done

  for package in $(cd $out/boot; echo *); do
    patch=$out/patches/$package.patch
    if [[ -e $patch ]]; then
      echo ">> patching package: $package"
      pushd $out/boot/$package
      patch -p1 < $patch
      rm $patch
      popd
    fi
  done
''
