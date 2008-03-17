{stdenv, coreutils, fetchsvn, m4, libtool, ghc, uulib, uuagc, llvm}:

stdenv.mkDerivation (rec {
  name = "ehc-svn-1036";
  homepage = "http://www.cs.uu.nl/wiki/Ehc/WebHome/";

  src = fetchsvn {
          url = https://svn.cs.uu.nl:12443/repos/EHC/trunk/EHC;
          rev = "1037";
          sha256 = "b2388cfadeb26ce716ff355fbdd73ba2e30219c5b423fbd609355b420300644c";
  };

  buildInputs = [coreutils m4 ghc libtool uulib uuagc llvm];

  preConfigure = ''
    find src -name files\*.mk -exec sed -i -- "s/--user//g" '{}' \;
    sed -i "s|/bin/date|${coreutils}/bin/date|g" mk/dist.mk
    echo "RTS_GCC_CC_OPTS := -std=gnu99" >> mk/shared.mk.in
  '';

  buildFlags = "100/ehc 100/ehclib";

  installPhase = ''
    cd bin

    # install executables
    echo "installing executables..."
    mkdir -p $out/bin-ehc
    for i in *; do
      if [[ -d $i ]]; then
        cp $i/ehc $out/bin-ehc/ehc-$i
      fi;
    done

    # install runtime support
    cp -r ../install/* $out

    # install prelude
    echo "installing prelude..."
    mkdir -p $out/lib-ehc
    for i in *; do
      if [[ -d ../build/$i/ehclib/ehcbase ]]; then
        mkdir -p $out/lib-ehc/$i
        cp -r ../build/$i/ehclib/ehcbase $out/lib-ehc/$i
      fi;
    done

    # generate wrappers
    echo "generating wrappers..."
    mkdir -p $out/bin
    for in in *; do
      if [[ -d $i ]]; then
        echo '#!'"$SHELL" > $out/bin/ehc-$i
        echo "exec \"$out/bin-ehc/ehc-$i\" -P $out/lib-ehc/$i/ehcbase" '"$@"' >> $out/bin/ehc-$i
        chmod 751 $out/bin/ehc-$i
      fi;
    done
  '';

  meta = {
    description = "Essential Haskell Compiler";
  };

  inherit coreutils;
})
