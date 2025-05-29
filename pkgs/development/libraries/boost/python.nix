{
  lib,
  stdenv,
  fetchpatch,
  boost,
  boost-build,
  libxcrypt,
  python,
  fixDarwinDylibNames,
  toolset ?
    if stdenv.cc.isClang then
      "clang"
    else if stdenv.cc.isGNU then
      "gcc"
    else
      null,
}:
let
  b2Args = lib.concatStringsSep " " (
    [
      "--with-python"
      "--user-config=user-config.jam"
      "--includedir=${lib.getInclude boost}/include"
      "--libdir=$out/lib"
      "-j$NIX_BUILD_CORES"
      "--layout=system"
      "variant=release"
      "debug-symbols=off"
      "threading=multi"
      "link=${if stdenv.hostPlatform.isStatic then "static" else "shared"}"
      "runtime-link=${if stdenv.hostPlatform.isStatic then "static" else "shared"}"
    ]
    ++ lib.optional (toolset != null) "toolset=${toolset}"
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "boost.python";
  inherit (boost) version src;
  meta = {
    inherit (boost.meta)
      homepage
      description
      license
      maintainers
      platforms
      ;
  };

  outputs = [
    "out"
    "dev"
  ];

  patches =
    lib.optional stdenv.hostPlatform.isDarwin ./darwin-no-system-python.patch
    ++ lib.optional (finalAttrs.version == "1.86.0") [
      (fetchpatch {
        name = "boost-python-numpy2-compat.patch";
        url = "https://github.com/boostorg/python/commit/0474de0f6cc9c6e7230aeb7164af2f7e4ccf74bf.patch";
        hash = "sha256-0IHK55JSujYcwEVOuLkwOa/iPEkdAKQlwVWR42p/X2U=";
        stripLen = 1;
        extraPrefix = "libs/python/";
      })
    ];

  strictDeps = true;

  nativeBuildInputs = [
    boost-build
  ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = [
    libxcrypt
    python
    python.pkgs.numpy
  ];

  propagatedBuildInputs = [ boost ];

  enableParallelBuilding = true;

  # b2 needs to be explicitly told how to find Python when cross-compiling
  preConfigure = ''
    cat << EOF >> user-config.jam
    import toolset : using ;
    using python : : ${python.pythonOnBuildForHost.interpreter}
      : ${python}/include/python${python.pythonVersion}
      : ${python}/lib
      ;
    EOF
  '';

  buildPhase = ''
    runHook preBuild
    b2 ${b2Args}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    b2 ${b2Args} install || true
    moveToOutput "lib/${python.libPrefix}" "$numpy"

    runHook postInstall
  '';

  postFixup =
    ''
      for lib in python numpy; do
        substituteInPlace $dev/lib/cmake/boost_$lib-${finalAttrs.version}/boost_$lib-config.cmake \
          --replace-fail "get_filename_component(_BOOST_LIBDIR \"\''${_BOOST_CMAKEDIR}/../\" ABSOLUTE)" \
                         "get_filename_component(_BOOST_LIBDIR \"\''${_BOOST_CMAKEDIR}/../../../''${out#${builtins.storeDir}/}/lib/\" ABSOLUTE)"
      done

      ln -s ${lib.getInclude boost}/include $dev/include
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      find $out/lib -type f -name '*.dylib' -exec install_name_tool -add_rpath $out/lib "{}" \;
    ''
    + lib.optionalString stdenv.hostPlatform.isMinGW ''
      $RANLIB "$out/lib/"*.a
    '';

  setOutputFlags = false;
})
