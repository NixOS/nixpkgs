{
  stdenv,
  darwin,
  lib,
  pkg-config,
  autoreconfHook,
  python3,
  doxygen,
  ncurses,
  findXMLCatalogs,
  libiconv,
  pythonSupport ? false,
  icuSupport ? false,
  icu,
  zlibSupport ? false,
  zlib,
  enableShared ? !stdenv.hostPlatform.isMinGW && !stdenv.hostPlatform.isStatic,
  enableStatic ? !enableShared,
  gnome,
  testers,
  enableHttp ? false,

  version,
  extraPatches ? [ ],
  src,
  extraMeta ? { },
  freezeUpdateScript ? false,
}:

let
  # libxml2 is a dependency of xcbuild. Avoid an infinite recursion by using a bootstrap stdenv
  # that does not propagate xcrun.
  stdenv' = if stdenv.hostPlatform.isDarwin then darwin.bootstrapStdenv else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  inherit
    version
    src
    ;

  pname = "libxml2";

  outputs = [
    "bin"
    "dev"
    "out"
  ]
  ++ lib.optional pythonSupport "py"
  ++ lib.optional (enableStatic && enableShared) "static";
  outputMan = "bin";

  patches = [ ] ++ extraPatches;

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ]
  ++ lib.optionals pythonSupport [
    doxygen
  ];

  buildInputs =
    lib.optionals pythonSupport [
      ncurses
      python3
    ]
    ++ lib.optionals zlibSupport [
      zlib
    ];

  propagatedBuildInputs = [
    findXMLCatalogs
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isMinGW) [
    libiconv
  ]
  ++ lib.optionals icuSupport [
    icu
  ];

  configureFlags = [
    "--exec-prefix=${placeholder "dev"}"
    (lib.enableFeature enableStatic "static")
    (lib.enableFeature enableShared "shared")
    (lib.withFeature icuSupport "icu")
    (lib.withFeature pythonSupport "python")
    (lib.optionalString pythonSupport "PYTHON=${python3.pythonOnBuildForHost.interpreter}")
    (lib.withFeature enableHttp "http")
    (lib.withFeature zlibSupport "zlib")
    (lib.withFeature false "docs") # docs are built with xsltproc, which would be a cyclic dependency
  ];

  installFlags = lib.optionals pythonSupport [
    "pythondir=\"${placeholder "py"}/${python3.sitePackages}\""
    "pyexecdir=\"${placeholder "py"}/${python3.sitePackages}\""
  ];

  enableParallelBuilding = true;

  doCheck = (stdenv.hostPlatform == stdenv.buildPlatform) && stdenv.hostPlatform.libc != "musl";
  preCheck = lib.optional stdenv.hostPlatform.isDarwin ''
    export DYLD_LIBRARY_PATH="$PWD/.libs:$DYLD_LIBRARY_PATH"
  '';

  preConfigure = lib.optionalString (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11") ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '';

  preInstall = lib.optionalString pythonSupport ''
    substituteInPlace python/libxml2mod.la --replace-fail "$dev/${python3.sitePackages}" "$py/${python3.sitePackages}"
  '';

  postFixup = ''
    moveToOutput bin/xml2-config "$dev"
    moveToOutput lib/xml2Conf.sh "$dev"
  ''
  + lib.optionalString (enableStatic && enableShared) ''
    moveToOutput lib/libxml2.a "$static"
  '';

  passthru = {
    inherit pythonSupport;

    updateScript = gnome.updateScript {
      packageName = "libxml2";
      versionPolicy = "none";
      freeze = freezeUpdateScript;
    };
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
      cmake-config = testers.hasCmakeConfigModules {
        moduleNames = [ "LibXml2" ];
        package = finalAttrs.finalPackage;
      };
    };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/libxml2";
    description = "XML parsing library for C";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    pkgConfigModules = [ "libxml-2.0" ];
    # Python limits cross-compilation to an allowlist of host OSes.
    # https://github.com/python/cpython/blob/dfad678d7024ab86d265d84ed45999e031a03691/configure.ac#L534-L562
    broken =
      pythonSupport
      && !(
        enableShared
        && (
          stdenv.hostPlatform == stdenv.buildPlatform
          || stdenv.hostPlatform.isCygwin
          || stdenv.hostPlatform.isLinux
          || stdenv.hostPlatform.isWasi
        )
      );
  }
  // extraMeta;
})
