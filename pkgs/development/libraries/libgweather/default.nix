{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, libxml2
, json-glib
, glib
, gettext
, libsoup_3
, gi-docgen
, gobject-introspection
, python3
, tzdata
, geocode-glib_2
, vala
, gnome
, withIntrospection ? stdenv.buildPlatform == stdenv.hostPlatform
}:

stdenv.mkDerivation rec {
  pname = "libgweather";
  version = "4.4.2";

  outputs = [ "out" "dev" ] ++ lib.optional withIntrospection "devdoc";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-puQntHcK2kiUXzqpBq9xD8gzz/DULfkfGCgwJ0DXlOw=";
  };

  patches = [
    # Headers depend on glib but it is only listed in Requires.private,
    # which does not influence Cflags on non-static builds in nixpkgs’s
    # pkg-config. Let’s add it to Requires to ensure Cflags are set correctly.
    ./fix-pkgconfig.patch
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    glib
    (python3.pythonOnBuildForHost.withPackages (ps: [ ps.pygobject3 ]))
  ] ++ lib.optionals withIntrospection [
    gi-docgen
    gobject-introspection
    vala
  ];

  buildInputs = [
    glib
    libsoup_3
    libxml2
    json-glib
    geocode-glib_2
  ];

  mesonFlags = [
    "-Dzoneinfo_dir=${tzdata}/share/zoneinfo"
    (lib.mesonBool "introspection" withIntrospection)
  ] ++ lib.optionals stdenv.isDarwin [
    "-Dc_args=-D_DARWIN_C_SOURCE"
  ];

  postPatch = ''
    patchShebangs build-aux/meson/gen_locations_variant.py

    # Run-time dependency gi-docgen found: NO (tried pkgconfig and cmake)
    # it should be a build-time dep for build
    # TODO: send upstream
    substituteInPlace doc/meson.build \
      --replace "'gi-docgen', ver" "'gi-docgen', native:true, ver" \
      --replace "'gi-docgen', req" "'gi-docgen', native:true, req"

    # gir works for us even when cross-compiling
    # TODO: send upstream because downstream users can use the option to disable gir if they don't have it working
    substituteInPlace libgweather/meson.build \
      --replace "g_ir_scanner.found() and not meson.is_cross_build()" "g_ir_scanner.found()"
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
      # Version 40.alpha preceded version 4.0.
      freeze = "40.alpha";
    };
  };

  meta = with lib; {
    description = "Library to access weather information from online services for numerous locations";
    homepage = "https://gitlab.gnome.org/GNOME/libgweather";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
