{ lib, stdenv
, fetchurl, perl, gcc
, ncurses5, ncurses6, gmp, glibc, libiconv
, llvmPackages
}:

# Prebuilt only does native
assert stdenv.targetPlatform == stdenv.hostPlatform;

let
  useLLVM = !stdenv.targetPlatform.isx86;

  useNcurses6 = stdenv.hostPlatform.system == "x86_64-linux";

  ourNcurses = if useNcurses6 then ncurses6 else ncurses5;

  libPath = lib.makeLibraryPath ([
    ourNcurses gmp
  ] ++ lib.optional (stdenv.hostPlatform.isDarwin) libiconv);

  libEnvVar = lib.optionalString stdenv.hostPlatform.isDarwin "DY"
    + "LD_LIBRARY_PATH";

  glibcDynLinker = assert stdenv.isLinux;
    if stdenv.hostPlatform.libc == "glibc" then
       # Could be stdenv.cc.bintools.dynamicLinker, keeping as-is to avoid rebuild.
       ''"$(cat $NIX_CC/nix-support/dynamic-linker)"''
    else
      "${lib.getLib glibc}/lib/ld-linux*";

  downloadsUrl = "https://downloads.haskell.org/ghc";

in

stdenv.mkDerivation rec {
  version = "8.6.5";

  name = "ghc-${version}-binary";

  # https://downloads.haskell.org/~ghc/8.6.5/
  src = fetchurl ({
    i686-linux = {
      # Don't use the Fedora27 build (as below) because there isn't one!
      url = "${downloadsUrl}/${version}/ghc-${version}-i386-deb9-linux.tar.xz";
      sha256 = "1p2h29qghql19ajk755xa0yxkn85slbds8m9n5196ris743vkp8w";
    };
    x86_64-linux = {
      # This is the Fedora build because it links against ncurses6 where the
      # deb9 one links against ncurses5, see here
      # https://github.com/NixOS/nixpkgs/issues/85924 for a discussion
      url = "${downloadsUrl}/${version}/ghc-${version}-x86_64-fedora27-linux.tar.xz";
      sha256 = "18dlqm5d028fqh6ghzn7pgjspr5smw030jjzl3kq6q1kmwzbay6g";
    };
    aarch64-linux = {
      url = "${downloadsUrl}/${version}/ghc-${version}-aarch64-ubuntu18.04-linux.tar.xz";
      sha256 = "11n7l2a36i5vxzzp85la2555q4m34l747g0pnmd81cp46y85hlhq";
    };
    x86_64-darwin = {
      url = "${downloadsUrl}/${version}/ghc-${version}-x86_64-apple-darwin.tar.xz";
      sha256 = "0s9188vhhgf23q3rjarwhbr524z6h2qga5xaaa2pma03sfqvvhfz";
    };
  }.${stdenv.hostPlatform.system}
    or (throw "cannot bootstrap GHC on this platform"));

  nativeBuildInputs = [ perl ];
  propagatedBuildInputs = lib.optionals useLLVM [ llvmPackages.llvm ];

  # Cannot patchelf beforehand due to relative RPATHs that anticipate
  # the final install location/
  ${libEnvVar} = libPath;

  postUnpack =
    # GHC has dtrace probes, which causes ld to try to open /usr/lib/libdtrace.dylib
    # during linking
    lib.optionalString stdenv.isDarwin ''
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

    # We have to patch the GMP paths for the integer-gmp package.
    ''
      find . -name integer-gmp.buildinfo \
          -exec sed -i "s@extra-lib-dirs: @extra-lib-dirs: ${gmp.out}/lib@" {} \;
    '' + lib.optionalString stdenv.isDarwin ''
      find . -name base.buildinfo \
          -exec sed -i "s@extra-lib-dirs: @extra-lib-dirs: ${libiconv}/lib@" {} \;
    '' +
    # Rename needed libraries and binaries, fix interpreter
    lib.optionalString stdenv.isLinux ''
      find . -type f -perm -0100 \
          -exec patchelf \
          --replace-needed libncurses${lib.optionalString stdenv.is64bit "w"}.so.5 libncurses.so \
          ${ # This isn't required for x86_64-linux where we use ncurses6
             lib.optionalString (!useNcurses6) "--replace-needed libtinfo.so libtinfo.so.5"
           } \
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
    lib.optionalString stdenv.hostPlatform.isMusl ''
      find ./ghc-${version}/rts -name "libHSrts*.a" -exec ''${OBJCOPY:-objcopy} --redefine-sym __strdup=strdup {} \;
    '';

  configurePlatforms = [ ];
  configureFlags = [
    "--with-gmp-libraries=${lib.getLib gmp}/lib"
    "--with-gmp-includes=${lib.getDev gmp}/include"
  ] ++ lib.optional stdenv.isDarwin "--with-gcc=${./gcc-clang-wrapper.sh}"
    ++ lib.optional stdenv.hostPlatform.isMusl "--disable-ld-override";

  # No building is necessary, but calling make without flags ironically
  # calls install-strip ...
  dontBuild = true;

  # On Linux, use patchelf to modify the executables so that they can
  # find editline/gmp.
  postFixup = lib.optionalString stdenv.isLinux ''
    for p in $(find "$out" -type f -executable); do
      if isELF "$p"; then
        echo "Patchelfing $p"
        patchelf --set-rpath "${libPath}:$(patchelf --print-rpath $p)" $p
      fi
    done
  '' + lib.optionalString stdenv.isDarwin ''
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

    # Our Cabal compiler name
    haskellCompilerName = "ghc-${version}";
  };

  meta = rec {
    license = lib.licenses.bsd3;
    platforms = ["x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin"];
    hydraPlatforms = builtins.filter (p: p != "aarch64-linux") platforms;
  };
}
