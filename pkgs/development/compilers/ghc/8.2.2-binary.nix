{ stdenv, substituteAll
, fetchurl, perl, gcc, llvm_39
, ncurses5, gmp, glibc, libiconv
}:

# Prebuilt only does native
assert stdenv.targetPlatform == stdenv.hostPlatform;

let
  libPath = stdenv.lib.makeLibraryPath ([
    ncurses5 gmp
  ] ++ stdenv.lib.optional (stdenv.hostPlatform.isDarwin) libiconv);

  libEnvVar = stdenv.lib.optionalString stdenv.hostPlatform.isDarwin "DY"
    + "LD_LIBRARY_PATH";

  glibcDynLinker = assert stdenv.isLinux;
    if stdenv.hostPlatform.libc == "glibc" then
       # Could be stdenv.cc.bintools.dynamicLinker, keeping as-is to avoid rebuild.
       ''"$(cat $NIX_CC/nix-support/dynamic-linker)"''
    else
      "${stdenv.lib.getLib glibc}/lib/ld-linux*";

in

stdenv.mkDerivation rec {
  version = "8.2.2";

  name = "ghc-${version}-binary";

  src = fetchurl ({
    "i686-linux" = {
      url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-i386-deb8-linux.tar.xz";
      sha256 = "08w2ik55dp3n95qikmrflc91lsiq01xp53ki3jlhnbj8fqnxfrwy";
    };
    "x86_64-linux" = {
      url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-x86_64-deb8-linux.tar.xz";
      sha256 = "0ahv26304pqi3dm7i78si4pxwvg5f5dc2jwsfgvcrhcx5g30bqj8";
    };
    "armv7l-linux" = {
      url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-armv7-deb8-linux.tar.xz";
      sha256 = "1jmv8qmnh5bn324fivbwdcaj55kvw7cb2zq9pafmlmv3qwwx7s46";
    };
    "aarch64-linux" = {
      url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-aarch64-deb8-linux.tar.xz";
      sha256 = "1k2amylcp1ad67c75h1pqf7czf9m0zj1i7hdc45ghjklnfq9hrk7";
    };
    "x86_64-darwin" = {
      url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-x86_64-apple-darwin.tar.xz";
      sha256 = "09swx71gh5habzbx55shz2xykgr96xkcy09nzinnm4z0yxicy3zr";
    };
  }.${stdenv.hostPlatform.system}
    or (throw "cannot bootstrap GHC on this platform"));

  nativeBuildInputs = [ perl ];
  buildInputs = stdenv.lib.optionals (stdenv.targetPlatform.isAarch32 || stdenv.targetPlatform.isAarch64) [ llvm_39 ];

  # Cannot patchelf beforehand due to relative RPATHs that anticipate
  # the final install location/
  ${libEnvVar} = libPath;

  postUnpack =
    # GHC has dtrace probes, which causes ld to try to open /usr/lib/libdtrace.dylib
    # during linking
    stdenv.lib.optionalString stdenv.isDarwin ''
      export NIX_LDFLAGS+=" -no_dtrace_dof"
      # not enough room in the object files for the full path to libiconv :(
      for exe in $(find . -type f -executable); do
        isScript $exe && continue
        ln -fs ${libiconv}/lib/libiconv.dylib $(dirname $exe)/libiconv.dylib
        install_name_tool -change /usr/lib/libiconv.2.dylib @executable_path/libiconv.dylib -change /usr/local/lib/gcc/6/libgcc_s.1.dylib ${gcc.cc.lib}/lib/libgcc_s.1.dylib $exe
      done
    '' +

    # Some scripts used during the build need to have their shebangs patched
    ''
      patchShebangs ghc-${version}/utils/
      patchShebangs ghc-${version}/configure
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
          --replace-needed libtinfo.so libtinfo.so.5 \
          --interpreter ${glibcDynLinker} {} \;

      sed -i "s|/usr/bin/perl|perl\x00        |" ghc-${version}/ghc/stage2/build/tmp/ghc-stage2
      sed -i "s|/usr/bin/gcc|gcc\x00        |" ghc-${version}/ghc/stage2/build/tmp/ghc-stage2
    '' +
    # We're kludging a glibc bindist into working with non-glibc...
    # Here we patch up the use of `__strdup` (part of glibc binary ABI)
    # to instead use `strdup` since musl doesn't provide __strdup
    # (`__strdup` is defined to be an alias of `strdup` anyway[1]).
    # [1] http://refspecs.linuxbase.org/LSB_4.0.0/LSB-Core-generic/LSB-Core-generic/baselib---strdup-1.html
    # Use objcopy magic to make the change:
    stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
      find ./ghc-${version}/rts -name "libHSrts*.a" -exec ''${OBJCOPY:-objcopy} --redefine-sym __strdup=strdup {} \;
    '';

  configurePlatforms = [ ];
  configureFlags =
  let
    gcc-clang-wrapper = substituteAll {
      inherit (stdenv) shell;
      isExecutable = true;
      src = ./gcc-clang-wrapper.sh;
    };
  in
  [ "--with-gmp-libraries=${stdenv.lib.getLib gmp}/lib"
    "--with-gmp-includes=${stdenv.lib.getDev gmp}/include"
  ] ++ stdenv.lib.optional stdenv.isDarwin            "--with-gcc=${gcc-clang-wrapper}"
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl "--disable-ld-override";

  # Stripping combined with patchelf breaks the executables (they die
  # with a segfault or the kernel even refuses the execve). (NIXPKGS-85)
  dontStrip = true;

  # No building is necessary, but calling make without flags ironically
  # calls install-strip ...
  dontBuild = true;

  # On Linux, use patchelf to modify the executables so that they can
  # find editline/gmp.
  preFixup = stdenv.lib.optionalString stdenv.isLinux ''
    for p in $(find "$out" -type f -executable); do
      if isELF "$p"; then
        echo "Patchelfing $p"
        patchelf --set-rpath "${libPath}:$(patchelf --print-rpath $p)" $p
      fi
    done
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    # not enough room in the object files for the full path to libiconv :(
    for exe in $(find "$out" -type f -executable); do
      isScript $exe && continue
      ln -fs ${libiconv}/lib/libiconv.dylib $(dirname $exe)/libiconv.dylib
      install_name_tool -change /usr/lib/libiconv.2.dylib @executable_path/libiconv.dylib -change /usr/local/lib/gcc/6/libgcc_s.1.dylib ${gcc.cc.lib}/lib/libgcc_s.1.dylib $exe
    done

    for file in $(find "$out" -name setup-config); do
      substituteInPlace $file --replace /usr/bin/ranlib "$(type -P ranlib)"
    done
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    unset ${libEnvVar}
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

  passthru = {
    targetPrefix = "";
    enableShared = true;
  };

  meta.license = stdenv.lib.licenses.bsd3;
  meta.platforms = ["x86_64-linux" "i686-linux" "x86_64-darwin" "armv7l-linux" "aarch64-linux"];
}
