{stdenv, fetchurl, perl, ncurses, gmp, libiconv, makeWrapper}:

stdenv.mkDerivation rec {
  version = "7.4.2";

  name = "ghc-${version}-binary";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-i386-unknown-linux.tar.bz2";
        sha256 = "0gny7knhss0w0d9r6jm1gghrcb8kqjvj94bb7hxf9syrk4fxlcxi";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-x86_64-unknown-linux.tar.bz2";
        sha256 = "043jabd0lh6n1zlqhysngbpvlsdznsa2mmsj08jyqgahw9sjb5ns";
      }
    else if stdenv.system == "i686-darwin" then
      fetchurl {
        url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-i386-apple-darwin.tar.bz2";
        sha256 = "1vrbs3pzki37hzym1f1nh07lrqh066z3ypvm81fwlikfsvk4djc0";
      }
    else if stdenv.system == "x86_64-darwin" then
      fetchurl {
        url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-x86_64-apple-darwin.tar.bz2";
        sha256 = "1imzqc0slpg0r6p40n5a9m18cbcm0m86z8dgyhfxcckksw54mzwf";
      }
    else throw "cannot bootstrap GHC on this platform";

  buildInputs = [perl];

  postUnpack =
    # GHC has dtrace probes, which causes ld to try to open /usr/lib/libdtrace.dylib
    # during linking
    stdenv.lib.optionalString stdenv.isDarwin ''
      export NIX_LDFLAGS+=" -no_dtrace_dof"
    '' +

    # Strip is harmful, see also below. It's important that this happens
    # first. The GHC Cabal build system makes use of strip by default and
    # has hardcoded paths to /usr/bin/strip in many places. We replace
    # those below, making them point to our dummy script.
     ''
      mkdir "$TMP/bin"
      for i in strip; do
        echo '#! ${stdenv.shell}' > "$TMP/bin/$i"
        chmod +x "$TMP/bin/$i"
      done
      PATH="$TMP/bin:$PATH"
     '' +
    # We have to patch the GMP paths for the integer-gmp package.
     ''
      find . -name integer-gmp.buildinfo \
          -exec sed -i "s@extra-lib-dirs: @extra-lib-dirs: ${gmp.out}/lib@" {} \;
     '' + stdenv.lib.optionalString stdenv.isDarwin ''
      find . -name base.buildinfo \
          -exec sed -i "s@extra-lib-dirs: @extra-lib-dirs: ${libiconv}/lib@" {} \;
     '' +
    # On Linux, use patchelf to modify the executables so that they can
    # find editline/gmp.
    stdenv.lib.optionalString stdenv.isLinux ''
      mkdir -p "$out/lib"
      ln -sv "${ncurses.out}/lib/libncurses.so" "$out/lib/libncurses${stdenv.lib.optionalString stdenv.is64bit "w"}.so.5"
      find . -type f -perm -0100 \
          -exec patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath "$out/lib:${gmp.out}/lib" {} \;
      sed -i "s|/usr/bin/perl|perl\x00        |" ghc-${version}/ghc/stage2/build/tmp/ghc-stage2
      sed -i "s|/usr/bin/gcc|gcc\x00        |" ghc-${version}/ghc/stage2/build/tmp/ghc-stage2
      for prog in ld ar gcc strip ranlib; do
        find . -name "setup-config" -exec sed -i "s@/usr/bin/$prog@$(type -p $prog)@g" {} \;
      done
     '' + stdenv.lib.optionalString stdenv.isDarwin ''
       # not enough room in the object files for the full path to libiconv :(
       fix () {
         install_name_tool -change /usr/lib/libiconv.2.dylib @executable_path/libiconv.dylib $1
       }

       ln -s ${libiconv}/lib/libiconv.dylib ghc-7.4.2/utils/ghc-pwd/dist-install/build/tmp
       ln -s ${libiconv}/lib/libiconv.dylib ghc-7.4.2/utils/hpc/dist-install/build/tmp
       ln -s ${libiconv}/lib/libiconv.dylib ghc-7.4.2/ghc/stage2/build/tmp

       for file in ghc-cabal ghc-pwd ghc-stage2 ghc-pkg haddock hsc2hs hpc; do
         fix $(find . -type f -name $file)
       done

       for file in $(find . -name setup-config); do
         substituteInPlace $file --replace /usr/bin/ranlib "$(type -P ranlib)"
       done
     '';

  configurePhase = ''
    ./configure --prefix=$out \
      --with-gmp-libraries=${gmp.out}/lib --with-gmp-includes=${gmp.dev}/include \
      ${stdenv.lib.optionalString stdenv.isDarwin "--with-gcc=${./gcc-clang-wrapper.sh}"}
  '';

  # Stripping combined with patchelf breaks the executables (they die
  # with a segfault or the kernel even refuses the execve). (NIXPKGS-85)
  dontStrip = true;

  # No building is necessary, but calling make without flags ironically
  # calls install-strip ...
  dontBuild = true;

  preInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/lib/ghc-7.4.2
    mkdir -p $out/bin
    ln -s ${libiconv}/lib/libiconv.dylib $out/bin
    ln -s ${libiconv}/lib/libiconv.dylib $out/lib/ghc-7.4.2/libiconv.dylib
    ln -s ${libiconv}/lib/libiconv.dylib utils/ghc-cabal/dist-install/build/tmp
  '';

  postInstall = ''
    # Sanity check, can ghc create executables?
    cd $TMP
    mkdir test-ghc; cd test-ghc
    cat > main.hs << EOF
      {-# LANGUAGE TemplateHaskell #-}
      module Main where
      main = putStrLn \$([|"yes"|])
    EOF
    $out/bin/ghc --make main.hs || exit 1
    echo compilation ok
    [ $(./main) == "yes" ]
  '';

  meta.license = stdenv.lib.licenses.bsd3;
  meta.platforms = ["x86_64-linux" "i686-linux" "x86_64-darwin"];
}
