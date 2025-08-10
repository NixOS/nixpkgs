{
  stdenv,
  lib,
  fetchFromGitLab,
  pkg-config,
  autoreconfHook,
  libintl,
  python,
  gettext,
  ncurses,
  findXMLCatalogs,
  libiconv,
  # Python limits cross-compilation to an allowlist of host OSes.
  # https://github.com/python/cpython/blob/dfad678d7024ab86d265d84ed45999e031a03691/configure.ac#L534-L562
  pythonSupport ?
    enableShared
    && (
      stdenv.hostPlatform == stdenv.buildPlatform
      || stdenv.hostPlatform.isCygwin
      || stdenv.hostPlatform.isLinux
      || stdenv.hostPlatform.isWasi
    ),
  icuSupport ? false,
  icu,
  zlibSupport ? false,
  zlib,
  enableShared ? !stdenv.hostPlatform.isMinGW && !stdenv.hostPlatform.isStatic,
  enableStatic ? !enableShared,
  gnome,
  testers,
  enableHttp ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxml2";
  version = "2.14.4-unstable-2025-06-20";

  outputs = [
    "bin"
    "dev"
    "out"
    "devdoc"
  ]
  ++ lib.optional pythonSupport "py"
  ++ lib.optional (enableStatic && enableShared) "static";
  outputMan = "bin";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libxml2";
    rev = "356542324fa439de544b5e419b91ae68d42c306c"; # some bugfixes right behind 2.14.4
    hash = "sha256-0jo08ECX+oP7Ekjgw3ZgOh+fSiNjlbjoZc4p3PqomJA=";
  };

  patches = [
    # Unmerged ABI-breaking patch required to fix the following security issues:
    # - https://gitlab.gnome.org/GNOME/libxslt/-/issues/139
    # - https://gitlab.gnome.org/GNOME/libxslt/-/issues/140
    # See also https://gitlab.gnome.org/GNOME/libxml2/-/issues/906
    # Source: https://github.com/chromium/chromium/blob/4fb4ae8ce3daa399c3d8ca67f2dfb9deffcc7007/third_party/libxml/chromium/xml-attr-extra.patch
    ./xml-attr-extra.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs =
    lib.optionals pythonSupport [
      python
    ]
    ++ lib.optionals (pythonSupport && python ? isPy2 && python.isPy2) [
      gettext
    ]
    ++ lib.optionals (pythonSupport && python ? isPy3 && python.isPy3) [
      ncurses
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && pythonSupport && python ? isPy2 && python.isPy2) [
      libintl
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
    (lib.optionalString pythonSupport "PYTHON=${python.pythonOnBuildForHost.interpreter}")
  ]
  # avoid rebuilds, can be merged into list in version bumps
  ++ lib.optional enableHttp "--with-http"
  ++ lib.optional zlibSupport "--with-zlib";

  installFlags = lib.optionals pythonSupport [
    "pythondir=\"${placeholder "py"}/${python.sitePackages}\""
    "pyexecdir=\"${placeholder "py"}/${python.sitePackages}\""
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
    substituteInPlace python/libxml2mod.la --replace-fail "$dev/${python.sitePackages}" "$py/${python.sitePackages}"
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

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/libxml2";
    description = "XML parsing library for C";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ jtojnar ];
    pkgConfigModules = [ "libxml-2.0" ];
  };
})
