{
  stdenv,
  lib,
  fetchurl,
  fetchpatch2,
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
  version = "2.13.8";

  outputs =
    [
      "bin"
      "dev"
      "out"
      "devdoc"
    ]
    ++ lib.optional pythonSupport "py"
    ++ lib.optional (enableStatic && enableShared) "static";
  outputMan = "bin";

  src = fetchurl {
    url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor finalAttrs.version}/libxml2-${finalAttrs.version}.tar.xz";
    hash = "sha256-J3KUyzMRmrcbK8gfL0Rem8lDW4k60VuyzSsOhZoO6Eo=";
  };

  patches = [
    # Unmerged ABI-breaking patch required to fix the following security issues:
    # - https://gitlab.gnome.org/GNOME/libxslt/-/issues/139
    # - https://gitlab.gnome.org/GNOME/libxslt/-/issues/140
    # See also https://gitlab.gnome.org/GNOME/libxml2/-/issues/906
    # Source: https://github.com/chromium/chromium/blob/4fb4ae8ce3daa399c3d8ca67f2dfb9deffcc7007/third_party/libxml/chromium/xml-attr-extra.patch
    ./xml-attr-extra.patch
    # same as upstream patch but fixed conflict and added required import:
    # https://gitlab.gnome.org/GNOME/libxml2/-/commit/acbbeef9f5dcdcc901c5f3fa14d583ef8cfd22f0.diff
    ./CVE-2025-6021.patch
    (fetchpatch2 {
      name = "CVE-2025-49794-49796.patch";
      url = "https://gitlab.gnome.org/GNOME/libxml2/-/commit/f7ebc65f05bffded58d1e1b2138eb124c2e44f21.patch";
      hash = "sha256-k+IGq6pbv9EA7o+uDocEAUqIammEjLj27Z+2RF5EMrs=";
    })
    (fetchpatch2 {
      name = "CVE-2025-49795.patch";
      url = "https://gitlab.gnome.org/GNOME/libxml2/-/commit/c24909ba2601848825b49a60f988222da3019667.patch";
      hash = "sha256-r7PYKr5cDDNNMtM3ogNLsucPFTwP/uoC7McijyLl4kU=";
      excludes = [ "runtest.c" ]; # tests were rewritten in C and are on schematron for 2.13.x, meaning this does not apply
    })
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

  propagatedBuildInputs =
    [
      findXMLCatalogs
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
    ]
    ++ lib.optionals icuSupport [
      icu
    ];

  configureFlags =
    [
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

  postFixup =
    ''
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
