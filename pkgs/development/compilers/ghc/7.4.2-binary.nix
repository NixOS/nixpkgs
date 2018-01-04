{ stdenv
, fetchurl, perl
, ncurses5, gmp, libiconv
}:

# Prebuilt only does native
assert stdenv.targetPlatform == stdenv.hostPlatform;

let
  libPath = stdenv.lib.makeLibraryPath ([
    ncurses5 gmp
  ] ++ stdenv.lib.optional (stdenv.hostPlatform.isDarwin) libiconv);

  libEnvVar = stdenv.lib.optionalString stdenv.hostPlatform.isDarwin "DY"
    + "LD_LIBRARY_PATH";

in

stdenv.mkDerivation rec {
  version = "7.4.2";

  name = "ghc-${version}-binary";

  src = fetchurl ({
    "i686-linux" = {
      url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-i386-unknown-linux.tar.bz2";
      sha256 = "0gny7knhss0w0d9r6jm1gghrcb8kqjvj94bb7hxf9syrk4fxlcxi";
    };
    "x86_64-linux" = {
      url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-x86_64-unknown-linux.tar.bz2";
      sha256 = "043jabd0lh6n1zlqhysngbpvlsdznsa2mmsj08jyqgahw9sjb5ns";
    };
    "i686-darwin" = {
      url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-i386-apple-darwin.tar.bz2";
      sha256 = "1vrbs3pzki37hzym1f1nh07lrqh066z3ypvm81fwlikfsvk4djc0";
    };
    "x86_64-darwin" = {
      url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-x86_64-apple-darwin.tar.bz2";
      sha256 = "1imzqc0slpg0r6p40n5a9m18cbcm0m86z8dgyhfxcckksw54mzwf";
    };
  }.${stdenv.hostPlatform.system}
    or (throw "cannot bootstrap GHC on this platform"));

  nativeBuildInputs = [ perl ];

  # Cannot patchelf beforehand due to relative RPATHs that anticipate
  # the final install location/
  ${libEnvVar} = libPath;

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
    # Rename needed libraries and binaries, fix interpreter
    stdenv.lib.optionalString stdenv.isLinux ''
      find . -type f -perm -0100 -exec patchelf \
          --replace-needed libncurses${stdenv.lib.optionalString stdenv.is64bit "w"}.so.5 libncurses.so \
          --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" {} \;

      paxmark m ./ghc-${version}/ghc/stage2/build/tmp/ghc-stage2

      sed -i "s|/usr/bin/perl|perl\x00        |" ghc-${version}/ghc/stage2/build/tmp/ghc-stage2
      sed -i "s|/usr/bin/gcc|gcc\x00        |" ghc-${version}/ghc/stage2/build/tmp/ghc-stage2
      for prog in ld ar gcc strip ranlib; do
        find . -name "setup-config" -exec sed -i "s@/usr/bin/$prog@$(type -p $prog)@g" {} \;
      done
    '';

  configurePlatforms = [ ];
  configureFlags = [
    "--with-gmp-libraries=${stdenv.lib.getLib gmp}/lib"
    "--with-gmp-includes=${stdenv.lib.getDev gmp}/include"
  ] ++ stdenv.lib.optional stdenv.isDarwin "--with-gcc=${./gcc-clang-wrapper.sh}";

  # Stripping combined with patchelf breaks the executables (they die
  # with a segfault or the kernel even refuses the execve). (NIXPKGS-85)
  dontStrip = true;

  # No building is necessary, but calling make without flags ironically
  # calls install-strip ...
  dontBuild = true;

  # On Linux, use patchelf to modify the executables so that they can
  # find editline/gmp.
  preFixup = stdenv.lib.optionalString stdenv.isLinux ''
    find "$out" -type f -executable \
        -exec patchelf --set-rpath "${libPath}" {} \;
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    # not enough room in the object files for the full path to libiconv :(
    for exe in $(find "$out" -type f -executable); do
      isScript $exe && continue
      ln -fs ${libiconv}/lib/libiconv.dylib $(dirname $exe)/libiconv.dylib
      install_name_tool -change /usr/lib/libiconv.2.dylib @executable_path/libiconv.dylib $exe
    done

    for file in $(find "$out" -name setup-config); do
      substituteInPlace $file --replace /usr/bin/ranlib "$(type -P ranlib)"
    done
  '';

  doInstallCheck = true;
  installCheckPhase = ''
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

  passthru = { targetPrefix = ""; };

  meta.license = stdenv.lib.licenses.bsd3;
  meta.platforms = ["x86_64-linux" "i686-linux" "x86_64-darwin"];
}
