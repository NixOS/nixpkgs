{
  lib,
  stdenv,
  fetchurl,
  perl,
  gcc,
  ncurses5,
  ncurses6,
  gmp,
  glibc,
  libiconv,
  llvmPackages,
  coreutils,
  targetPackages,
}:

# Prebuilt only does native
assert stdenv.targetPlatform == stdenv.hostPlatform;

let
  useLLVM =
    !(stdenv.targetPlatform.isx86 || stdenv.targetPlatform.isPower || stdenv.targetPlatform.isSparc);

  useNcurses6 =
    stdenv.hostPlatform.system == "x86_64-linux"
    || (with stdenv.hostPlatform; isPower64 && isLittleEndian);

  ourNcurses = if useNcurses6 then ncurses6 else ncurses5;

  libPath = lib.makeLibraryPath (
    [
      ourNcurses
      gmp
    ]
    ++ lib.optional (stdenv.hostPlatform.isDarwin) libiconv
  );

  libEnvVar = lib.optionalString stdenv.hostPlatform.isDarwin "DY" + "LD_LIBRARY_PATH";

  glibcDynLinker =
    assert stdenv.hostPlatform.isLinux;
    if stdenv.hostPlatform.libc == "glibc" then
      # Could be stdenv.cc.bintools.dynamicLinker, keeping as-is to avoid rebuild.
      ''"$(cat $NIX_CC/nix-support/dynamic-linker)"''
    else
      "${lib.getLib glibc}/lib/ld-linux*";

  downloadsUrl = "https://downloads.haskell.org/ghc";

  runtimeDeps =
    [
      targetPackages.stdenv.cc
      targetPackages.stdenv.cc.bintools
      coreutils # for cat
    ]
    ++
      lib.optionals
        (
          assert useLLVM -> !(llvmPackages == null);
          useLLVM
        )
        [
          (lib.getBin llvmPackages.llvm)
        ]
    # On darwin, we need unwrapped bintools as well (for otool)
    ++ lib.optionals (stdenv.targetPlatform.linker == "cctools") [
      targetPackages.stdenv.cc.bintools.bintools
    ];

in

stdenv.mkDerivation rec {
  version = "8.6.5";
  pname = "ghc-binary";

  # https://downloads.haskell.org/~ghc/8.6.5/
  src = fetchurl (
    {
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
      x86_64-darwin = {
        url = "${downloadsUrl}/${version}/ghc-${version}-x86_64-apple-darwin.tar.xz";
        sha256 = "0s9188vhhgf23q3rjarwhbr524z6h2qga5xaaa2pma03sfqvvhfz";
      };
      powerpc64le-linux = {
        url = "https://downloads.haskell.org/~ghc/${version}/ghc-${version}-powerpc64le-fedora29-linux.tar.xz";
        sha256 = "sha256-tWSsJdPVrCiqDyIKzpBt5DaXb3b6j951tCya584kWs4=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "cannot bootstrap GHC on this platform")
  );

  nativeBuildInputs = [ perl ];

  # Cannot patchelf beforehand due to relative RPATHs that anticipate
  # the final install location/
  ${libEnvVar} = libPath;

  postUnpack =
    # GHC has dtrace probes, which causes ld to try to open /usr/lib/libdtrace.dylib
    # during linking
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      export NIX_LDFLAGS+=" -no_dtrace_dof"
      # not enough room in the object files for the full path to libiconv :(
      for exe in $(find . -type f -executable); do
        isScript $exe && continue
        ln -fs ${libiconv}/lib/libiconv.dylib $(dirname $exe)/libiconv.dylib
        install_name_tool -change /usr/lib/libiconv.2.dylib @executable_path/libiconv.dylib -change /usr/local/lib/gcc/6/libgcc_s.1.dylib ${gcc.cc.lib}/lib/libgcc_s.1.dylib $exe
      done
    ''
    +

      # Some scripts used during the build need to have their shebangs patched
      ''
        patchShebangs ghc-${version}/utils/
        patchShebangs ghc-${version}/configure
        test -d ghc-${version}/inplace/bin && \
          patchShebangs ghc-${version}/inplace/bin
      ''
    +

      # We have to patch the GMP paths for the integer-gmp package.
      ''
        find . -name integer-gmp.buildinfo \
            -exec sed -i "s@extra-lib-dirs: @extra-lib-dirs: ${gmp.out}/lib@" {} \;
      ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      find . -name base.buildinfo \
          -exec sed -i "s@extra-lib-dirs: @extra-lib-dirs: ${libiconv}/lib@" {} \;
    ''
    +
      # Rename needed libraries and binaries, fix interpreter
      lib.optionalString stdenv.hostPlatform.isLinux ''
        find . -type f -perm -0100 \
            -exec patchelf \
            --replace-needed libncurses${lib.optionalString stdenv.hostPlatform.is64bit "w"}.so.5 libncurses.so \
            ${
              # This isn't required for x86_64-linux where we use ncurses6
              lib.optionalString (!useNcurses6) "--replace-needed libtinfo.so libtinfo.so.5"
            } \
            --interpreter ${glibcDynLinker} {} \;

        sed -i "s|/usr/bin/perl|perl\x00        |" ghc-${version}/ghc/stage2/build/tmp/ghc-stage2
        sed -i "s|/usr/bin/gcc|gcc\x00        |" ghc-${version}/ghc/stage2/build/tmp/ghc-stage2
      ''
    +
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
  configureFlags =
    [
      "--with-gmp-includes=${lib.getDev gmp}/include"
      # Note `--with-gmp-libraries` does nothing for GHC bindists:
      # https://gitlab.haskell.org/ghc/ghc/-/merge_requests/6124
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin "--with-gcc=${./gcc-clang-wrapper.sh}"
    ++ lib.optional stdenv.hostPlatform.isMusl "--disable-ld-override";

  # No building is necessary, but calling make without flags ironically
  # calls install-strip ...
  dontBuild = true;

  # Patch scripts to include runtime dependencies in $PATH.
  postInstall = ''
    for i in "$out/bin/"*; do
      test ! -h "$i" || continue
      isScript "$i" || continue
      sed -i -e '2i export PATH="${lib.makeBinPath runtimeDeps}:$PATH"' "$i"
    done
  '';

  # On Linux, use patchelf to modify the executables so that they can
  # find editline/gmp.
  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      for p in $(find "$out" -type f -executable); do
        if isELF "$p"; then
          echo "Patchelfing $p"
          patchelf --set-rpath "${libPath}:$(patchelf --print-rpath $p)" $p
        fi
      done
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
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

  # In nixpkgs, musl based builds currently enable `pie` hardening by default
  # (see `defaultHardeningFlags` in `make-derivation.nix`).
  # But GHC cannot currently produce outputs that are ready for `-pie` linking.
  # Thus, disable `pie` hardening, otherwise `recompile with -fPIE` errors appear.
  # See:
  # * https://github.com/NixOS/nixpkgs/issues/129247
  # * https://gitlab.haskell.org/ghc/ghc/-/issues/19580
  hardeningDisable = lib.optional stdenv.targetPlatform.isMusl "pie";

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
    env -i $out/bin/ghc --make main.hs || exit 1
    echo compilation ok
    [ $(./main) == "yes" ]
  '';

  passthru = {
    targetPrefix = "";
    enableShared = true;

    inherit llvmPackages;

    # Our Cabal compiler name
    haskellCompilerName = "ghc-${version}";
  };

  meta = rec {
    license = lib.licenses.bsd3;
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "x86_64-darwin"
      "powerpc64le-linux"
    ];
    # build segfaults, use ghc8107Binary which has proper musl support instead
    broken = stdenv.hostPlatform.isMusl;
    maintainers =
      with lib.maintainers;
      [
        guibou
      ]
      ++ lib.teams.haskell.members;
  };
}
