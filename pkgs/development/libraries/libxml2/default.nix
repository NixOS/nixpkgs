{ stdenv
, lib
, fetchurl
, zlib
, pkg-config
, autoreconfHook
, xz
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
}:

let
  # Newer versions fail with minimal python, probably because
  # https://gitlab.gnome.org/GNOME/libxml2/-/commit/b706824b612adb2c8255819c9a55e78b52774a3c
  # This case is encountered "temporarily" during stdenv bootstrapping on darwin.
  # Beware that the old version has known security issues, so the final set shouldn't use it.
  oldVer = python.pname == "python3-minimal";
in
  assert oldVer -> stdenv.isDarwin; # reduce likelihood of using old libxml2 unintentionally

let
libxml = stdenv.mkDerivation rec {
  pname = "libxml2";
  version = "2.11.5";

  outputs = [ "bin" "dev" "out" "doc" ]
    ++ lib.optional pythonSupport "py"
    ++ lib.optional (enableStatic && enableShared) "static";
  outputMan = "bin";

  src = fetchurl {
    url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor version}/libxml2-${version}.tar.xz";
    sha256 = "NyeweMNg7Gn6hp3hS9b3XX7o02mHsHHmko1HIKKN86Y=";
  };

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
  ] ++ lib.optionals stdenv.isFreeBSD [
    # Libxml2 has an optional dependency on liblzma.  However, on impure
    # platforms, it may end up using that from /usr/lib, and thus lack a
    # RUNPATH for that, leading to undefined references for its users.
    xz
  ];

  propagatedBuildInputs = [
    zlib
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
    (lib.optionalString pythonSupport "PYTHON=${python.pythonForBuild.interpreter}")
  ];

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
    substituteInPlace python/libxml2mod.la --replace "$dev/${python.sitePackages}" "$py/${python.sitePackages}"
  '';

  postFixup = ''
    moveToOutput bin/xml2-config "$dev"
    moveToOutput lib/xml2Conf.sh "$dev"
  '' + lib.optionalString (enableStatic && enableShared) ''
    moveToOutput lib/libxml2.a "$static"
  '';

  passthru = {
    inherit version;
    pythonSupport = pythonSupport;

    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/libxml2";
    description = "XML parsing library for C";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ eelco jtojnar ];
  };
};
in
if oldVer then
  libxml.overrideAttrs (attrs: rec {
    version = "2.10.1";
    src = fetchurl {
      url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor version}/libxml2-${version}.tar.xz";
      sha256 = "21a9e13cc7c4717a6c36268d0924f92c3f67a1ece6b7ff9d588958a6db9fb9d8";
    };
  })
else
  libxml
