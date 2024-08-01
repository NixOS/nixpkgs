{ stdenv
, lib
, fetchurl
, fetchpatch
, pkg-config
, autoreconfHook
, libintl
, python
, gettext
, ncurses
, findXMLCatalogs
, libiconv
# Python limits cross-compilation to an allowlist of host OSes.
# https://github.com/python/cpython/blob/dfad678d7024ab86d265d84ed45999e031a03691/configure.ac#L534-L562
, pythonSupport ? enableShared &&
    (stdenv.hostPlatform == stdenv.buildPlatform || stdenv.hostPlatform.isCygwin || stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isWasi)
, icuSupport ? false
, icu
, enableShared ? !stdenv.hostPlatform.isMinGW && !stdenv.hostPlatform.isStatic
, enableStatic ? !enableShared
, gnome
, testers
, enableHttp ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxml2";
  version = "2.13.2";

  outputs = [ "bin" "dev" "out" "devdoc" ]
    ++ lib.optional pythonSupport "py"
    ++ lib.optional (enableStatic && enableShared) "static";
  outputMan = "bin";

  src = fetchurl {
    url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor finalAttrs.version}/libxml2-${finalAttrs.version}.tar.xz";
    hash = "sha256-58j14LVUIVng3cQJwiyRZDBLWB6qmTBlOnb7hFsWkmM=";
  };

  patches = [
    # Fix XInclude failing too aggresively.
    # https://gitlab.gnome.org/GNOME/libxml2/-/issues/772
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libxml2/-/commit/a0330b53c8034bb79220e403e8d4ad8c23ef088f.patch";
      hash = "sha256-iVAgX8qNF0fw8GYUKsWduudjEuRMEOTAENAIFTjyRjU=";
    })
    # Fix error handling
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libxml2/-/commit/ed8b4264f65b1ced1e3b13967dd1cf90102cfa40.patch";
      hash = "sha256-EvxoUcr+VXBbYvK1PBV+KWcWTDk9rMWf+GXCYvXWDMI=";
    })
    # Fix more error handling
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libxml2/-/commit/e30cb632e734394ddbd7bd62b57cee3586424352.patch";
      hash = "sha256-C0ef17wTRC9rH0dKua/LJwwqTRI5W8sKWmvL7JxzT4o=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = lib.optionals pythonSupport [
    python
  ] ++ lib.optionals (pythonSupport && python?isPy2 && python.isPy2) [
    gettext
  ] ++ lib.optionals (pythonSupport && python?isPy3 && python.isPy3) [
    ncurses
  ] ++ lib.optionals (stdenv.isDarwin && pythonSupport && python?isPy2 && python.isPy2) [
    libintl
  ];

  propagatedBuildInputs = [
    findXMLCatalogs
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
  ] ++ lib.optionals icuSupport [
    icu
  ];

  configureFlags = [
    "--exec-prefix=${placeholder "dev"}"
    (lib.enableFeature enableStatic "static")
    (lib.enableFeature enableShared "shared")
    (lib.withFeature icuSupport "icu")
    (lib.withFeature pythonSupport "python")
    (lib.optionalString pythonSupport "PYTHON=${python.pythonOnBuildForHost.interpreter}")
  ] ++ lib.optional enableHttp "--with-http";

  installFlags = lib.optionals pythonSupport [
    "pythondir=\"${placeholder "py"}/${python.sitePackages}\""
    "pyexecdir=\"${placeholder "py"}/${python.sitePackages}\""
  ];

  enableParallelBuilding = true;

  doCheck =
    (stdenv.hostPlatform == stdenv.buildPlatform) &&
    stdenv.hostPlatform.libc != "musl";
  preCheck = lib.optional stdenv.isDarwin ''
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
  '' + lib.optionalString (enableStatic && enableShared) ''
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
    maintainers = with maintainers; [ eelco jtojnar ];
    pkgConfigModules = [ "libxml-2.0" ];
  };
})
