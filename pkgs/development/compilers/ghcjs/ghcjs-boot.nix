{ runCommand, fetchgit }:

let
  src = fetchgit {
    url = git://github.com/ghcjs/ghcjs-boot.git;
    rev = "97dea5c4145bf80a1e7cffeb1ecd4d0ecacd5a2f";
    sha256 = "1cgjzm595l2dx6fibzbkyv23bp1857qia0hb9d8aghf006al558j";
    fetchSubmodules = true;
  };

in

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
