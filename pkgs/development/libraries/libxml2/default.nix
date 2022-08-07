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
, pythonSupport ? enableShared && stdenv.buildPlatform == stdenv.hostPlatform
, icuSupport ? false
, icu
, enableShared ? stdenv.hostPlatform.libc != "msvcrt" && !stdenv.hostPlatform.isStatic
, enableStatic ? !enableShared
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libxml2";
  version = "2.9.14";

  outputs = [ "bin" "dev" "out" "man" "doc" ]
    ++ lib.optional pythonSupport "py"
    ++ lib.optional (enableStatic && enableShared) "static";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1vnzk33wfms348lgz9pvkq9li7jm44pvm73lbr3w1khwgljlmmv0";
  };

  patches = [
    # Upstream bugs:
    #   https://bugzilla.gnome.org/show_bug.cgi?id=789714
    #   https://gitlab.gnome.org/GNOME/libxml2/issues/64
    # Patch from https://bugzilla.opensuse.org/show_bug.cgi?id=1065270 ,
    # but only the UTF-8 part.
    # Can also be mitigated by fixing malformed XML inputs, such as in
    # https://gitlab.gnome.org/GNOME/gnumeric/merge_requests/3 .
    # Other discussion:
    #   https://github.com/itstool/itstool/issues/22
    #   https://github.com/NixOS/nixpkgs/pull/63174
    #   https://github.com/NixOS/nixpkgs/pull/72342
    ./utf8-xmlErrorFuncHandler.patch
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
    (lib.withFeatureAs pythonSupport "python" python)
  ];

  installFlags = lib.optionals pythonSupport [
    "pythondir=\"${placeholder "py"}/${python.sitePackages}\""
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
    moveToOutput share/man/man1 "$bin"
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
}
