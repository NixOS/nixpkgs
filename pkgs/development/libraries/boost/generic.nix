{
  lib,
  stdenv,
  icu,
  expat,
  zlib,
  bzip2,
  zstd,
  xz,
  python ? null,
  fixDarwinDylibNames,
  libiconv,
  libxcrypt,
  makePkgconfigItem,
  copyPkgconfigItems,
  boost-build,
  fetchpatch,
  which,
  toolset ?
    if stdenv.cc.isClang then
      "clang"
    else if stdenv.cc.isGNU then
      "gcc"
    else
      null,
  enableRelease ? true,
  enableDebug ? false,
  enableSingleThreaded ? false,
  enableMultiThreaded ? true,
  enableShared ? !(with stdenv.hostPlatform; isStatic || isMinGW), # problems for now
  enableStatic ? !enableShared,
  enablePython ? false,
  enableNumpy ? false,
  enableIcu ? stdenv.hostPlatform == stdenv.buildPlatform,
  taggedLayout ? (
    (enableRelease && enableDebug)
    || (enableSingleThreaded && enableMultiThreaded)
    || (enableShared && enableStatic)
  ),
  patches ? [ ],
  boostBuildPatches ? [ ],
  useMpi ? false,
  mpi,
  extraB2Args ? [ ],

  # Attributes inherit from specific versions
  version,
  src,
  ...
}:

# We must build at least one type of libraries
assert enableShared || enableStatic;

assert enableNumpy -> enablePython;

let

  variant = lib.concatStringsSep "," (
    lib.optional enableRelease "release" ++ lib.optional enableDebug "debug"
  );

  threading = lib.concatStringsSep "," (
    lib.optional enableSingleThreaded "single" ++ lib.optional enableMultiThreaded "multi"
  );

  link = lib.concatStringsSep "," (
    lib.optional enableShared "shared" ++ lib.optional enableStatic "static"
  );

  runtime-link = if enableShared then "shared" else "static";

  # To avoid library name collisions
  layout = if taggedLayout then "tagged" else "system";

  needUserConfig =
    stdenv.hostPlatform != stdenv.buildPlatform
    || useMpi
    || (stdenv.hostPlatform.isDarwin && enableShared);

  b2Args = lib.concatStringsSep " " (
    [
      "--includedir=$dev/include"
      "--libdir=$out/lib"
      "-j$NIX_BUILD_CORES"
      "--layout=${layout}"
      "variant=${variant}"
      "threading=${threading}"
      "link=${link}"
      "-sEXPAT_INCLUDE=${expat.dev}/include"
      "-sEXPAT_LIBPATH=${expat.out}/lib"
      (
        # The stacktrace from exception feature causes memory leaks when built
        # with libc++. For all other standard library implementations, i.e.
        # libstdc++, we must aknowledge this or stacktrace refuses to compile.
        # Issue upstream: https://github.com/boostorg/stacktrace/issues/163
        if (stdenv.cc.libcxx != null) then
          "boost.stacktrace.from_exception=off"
        else
          "define=BOOST_STACKTRACE_LIBCXX_RUNTIME_MAY_CAUSE_MEMORY_LEAK"
      )

      # TODO: make this unconditional
    ]
    ++
      lib.optionals
        (
          stdenv.hostPlatform != stdenv.buildPlatform
          ||
            # required on mips; see 61d9f201baeef4c4bb91ad8a8f5f89b747e0dfe4
            (stdenv.hostPlatform.isMips && lib.versionAtLeast version "1.79")
        )
        [
          "address-model=${toString stdenv.hostPlatform.parsed.cpu.bits}"
          "architecture=${
            if stdenv.hostPlatform.isMips64 then
              if lib.versionOlder version "1.78" then "mips1" else "mips"
            else if stdenv.hostPlatform.isS390 then
              "s390x"
            else
              toString stdenv.hostPlatform.parsed.cpu.family
          }"
          # env in host triplet for Mach-O is "macho", but boost binary format for Mach-O is "mach-o"
          "binary-format=${
            if stdenv.hostPlatform.isMacho then
              "mach-o"
            else
              toString stdenv.hostPlatform.parsed.kernel.execFormat.name
          }"
          "target-os=${toString stdenv.hostPlatform.parsed.kernel.name}"

          # adapted from table in boost manual
          # https://www.boost.org/doc/libs/1_66_0/libs/context/doc/html/context/architectures.html
          "abi=${
            if stdenv.hostPlatform.parsed.cpu.family == "arm" then
              "aapcs"
            else if stdenv.hostPlatform.isWindows then
              "ms"
            else if stdenv.hostPlatform.isMips32 then
              "o32"
            else if stdenv.hostPlatform.isMips64n64 then
              "n64"
            else
              "sysv"
          }"
        ]
    ++ lib.optional (link != "static") "runtime-link=${runtime-link}"
    ++ lib.optional (variant == "release") "debug-symbols=off"
    ++ lib.optional (toolset != null) "toolset=${toolset}"
    ++ lib.optional (!enablePython) "--without-python"
    ++ lib.optional needUserConfig "--user-config=user-config.jam"
    ++ lib.optional (stdenv.buildPlatform.isDarwin && stdenv.hostPlatform.isLinux) "pch=off"
    ++ lib.optionals stdenv.hostPlatform.isMinGW [
      "threadapi=win32"
    ]
    ++ extraB2Args
  );

in

stdenv.mkDerivation {
  pname = "boost";

  inherit src version;

  patchFlags = [ ];

  patches =
    patches
    ++ lib.optional stdenv.hostPlatform.isDarwin ./darwin-no-system-python.patch
    ++ [ ./cmake-paths-173.patch ]
    ++ lib.optional (version == "1.77.0") (fetchpatch {
      url = "https://github.com/boostorg/math/commit/7d482f6ebc356e6ec455ccb5f51a23971bf6ce5b.patch";
      relative = "include";
      sha256 = "sha256-KlmIbixcds6GyKYt1fx5BxDIrU7msrgDdYo9Va/KJR4=";
    })
    # Fixes ABI detection
    ++ lib.optional (version == "1.83.0") (fetchpatch {
      url = "https://github.com/boostorg/context/commit/6fa6d5c50d120e69b2d8a1c0d2256ee933e94b3b.patch";
      stripLen = 1;
      extraPrefix = "libs/context/";
      sha256 = "sha256-bCfLL7bD1Rn4Ie/P3X+nIcgTkbXdCX6FW7B9lHsmVW8=";
    })
    # This fixes another issue regarding ill-formed constant expressions, which is a default error
    # in clang 16 and will be a hard error in clang 17.
    ++ lib.optional (lib.versionOlder version "1.80") (fetchpatch {
      url = "https://github.com/boostorg/log/commit/77f1e20bd69c2e7a9e25e6a9818ae6105f7d070c.patch";
      relative = "include";
      hash = "sha256-6qOiGJASm33XzwoxVZfKJd7sTlQ5yd+MMFQzegXm5RI=";
    })
    ++ lib.optionals (lib.versionOlder version "1.81") [
      # libc++ 15 dropped support for `std::unary_function` and `std::binary_function` in C++17+.
      # C++17 is the default for clang 16, but clang 15 is also affected in that language mode.
      # This patch is for Boost 1.80, but it also applies to earlier versions.
      (fetchpatch {
        url = "https://www.boost.org/patches/1_80_0/0005-config-libcpp15.patch";
        hash = "sha256-ULFMzKphv70unvPZ3o4vSP/01/xbSM9a2TlIV67eXDQ=";
      })
      # This fixes another ill-formed contant expressions issue flagged by clang 16.
      (fetchpatch {
        url = "https://github.com/boostorg/numeric_conversion/commit/50a1eae942effb0a9b90724323ef8f2a67e7984a.patch";
        relative = "include";
        hash = "sha256-dq4SVgxkPJSC7Fvr59VGnXkM4Lb09kYDaBksCHo9C0s=";
      })
      # This fixes an issue in Python 3.11 about Py_TPFLAGS_HAVE_GC
      (fetchpatch {
        name = "python311-compatibility.patch";
        url = "https://github.com/boostorg/python/commit/a218babc8daee904a83f550fb66e5cb3f1cb3013.patch";
        hash = "sha256-IHxLtJBx0xSy7QEr8FbCPofsjcPuSYzgtPwDlx1JM+4=";
        stripLen = 1;
        extraPrefix = "libs/python/";
      })
    ]
    ++ lib.optional (lib.versionAtLeast version "1.81" && stdenv.cc.isClang) ./fix-clang-target.patch
    ++ lib.optional (lib.versionAtLeast version "1.86") [
      # Backport fix for NumPy 2 support.
      (fetchpatch {
        name = "boost-numpy-2-compatibility.patch";
        url = "https://github.com/boostorg/python/commit/0474de0f6cc9c6e7230aeb7164af2f7e4ccf74bf.patch";
        stripLen = 1;
        extraPrefix = "libs/python/";
        hash = "sha256-0IHK55JSujYcwEVOuLkwOa/iPEkdAKQlwVWR42p/X2U=";
      })
    ];

  meta = with lib; {
    homepage = "http://boost.org/";
    description = "Collection of C++ libraries";
    license = licenses.boost;
    platforms = platforms.unix ++ platforms.windows;
    # boost-context lacks support for the N32 ABI on mips64.  The build
    # will succeed, but packages depending on boost-context will fail with
    # a very cryptic error message.
    badPlatforms = [ lib.systems.inspect.patterns.isMips64n32 ];
    maintainers = with maintainers; [ hjones2199 ];
    broken =
      enableNumpy && lib.versionOlder version "1.86" && lib.versionAtLeast python.pkgs.numpy.version "2";
  };

  passthru = {
    inherit boostBuildPatches;
  };

  preConfigure =
    lib.optionalString useMpi ''
      cat << EOF >> user-config.jam
      using mpi : ${lib.getDev mpi}/bin/mpiCC ;
      EOF
    ''
    # On darwin we need to add the `$out/lib` to the libraries' rpath explicitly,
    # otherwise the dynamic linker is unable to resolve the reference to @rpath
    # when the boost libraries want to load each other at runtime.
    + lib.optionalString (stdenv.hostPlatform.isDarwin && enableShared) ''
      cat << EOF >> user-config.jam
      using clang-darwin : : ${stdenv.cc.targetPrefix}c++
        : <linkflags>"-rpath $out/lib/"
          <archiver>$AR
          <ranlib>$RANLIB
        ;
      EOF
    ''
    # b2 has trouble finding the correct compiler and tools for cross compilation
    # since it apparently ignores $CC, $AR etc. Thus we need to set everything
    # in user-config.jam. To keep things simple we just set everything in an
    # uniform way for clang and gcc (which works thanks to our cc-wrapper).
    # We pass toolset later which will make b2 invoke everything in the right
    # way -- the other toolset in user-config.jam will be ignored.
    + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
      cat << EOF >> user-config.jam
      using gcc : cross : ${stdenv.cc.targetPrefix}c++
        : <archiver>$AR
          <ranlib>$RANLIB
        ;

      using clang : cross : ${stdenv.cc.targetPrefix}c++
        : <archiver>$AR
          <ranlib>$RANLIB
        ;
      EOF
    ''
    # b2 needs to be explicitly told how to find Python when cross-compiling
    + lib.optionalString enablePython ''
      cat << EOF >> user-config.jam
      using python : : ${python.interpreter}
        : ${python}/include/python${python.pythonVersion}
        : ${python}/lib
        ;
      EOF
    '';

  env = {
    NIX_CFLAGS_LINK = lib.optionalString stdenv.hostPlatform.isDarwin "-headerpad_max_install_names";
    # copyPkgconfigItems will substitute these in the pkg-config file
    includedir = "${placeholder "dev"}/include";
    libdir = "${placeholder "out"}/lib";
  };

  pkgconfigItems = [
    (makePkgconfigItem {
      name = "boost";
      inherit version;
      # Exclude other variables not needed by meson
      variables = {
        includedir = "@includedir@";
        libdir = "@libdir@";
      };
    })
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    which
    boost-build
    copyPkgconfigItems
  ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs =
    [
      expat
      zlib
      bzip2
      libiconv
    ]
    ++ lib.optional (lib.versionAtLeast version "1.69") zstd
    ++ [ xz ]
    ++ lib.optional enableIcu icu
    ++ lib.optionals enablePython [
      libxcrypt
      python
    ]
    ++ lib.optional enableNumpy python.pkgs.numpy;

  configureScript = "./bootstrap.sh";
  configurePlatforms = [ ];
  dontDisableStatic = true;
  dontAddStaticConfigureFlags = true;
  configureFlags =
    [
      "--includedir=$(dev)/include"
      "--libdir=$(out)/lib"
      "--with-bjam=b2" # prevent bootstrapping b2 in configurePhase
    ]
    ++ lib.optional (toolset != null) "--with-toolset=${toolset}"
    ++ [ (if enableIcu then "--with-icu=${icu.dev}" else "--without-icu") ];

  buildPhase = ''
    runHook preBuild
    b2 ${b2Args}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # boostbook is needed by some applications
    mkdir -p $dev/share/boostbook
    cp -a tools/boostbook/{xsl,dtd} $dev/share/boostbook/

    # Let boost install everything else
    b2 ${b2Args} install

    runHook postInstall
  '';

  postFixup =
    ''
      # Make boost header paths relative so that they are not runtime dependencies
      cd "$dev" && find include \( -name '*.hpp' -or -name '*.h' -or -name '*.ipp' \) \
        -exec sed '1s/^\xef\xbb\xbf//;1i#line 1 "{}"' -i '{}' \;
    ''
    + lib.optionalString stdenv.hostPlatform.isMinGW ''
      $RANLIB "$out/lib/"*.a
    '';

  outputs = [
    "out"
    "dev"
  ];
  setOutputFlags = false;
}
