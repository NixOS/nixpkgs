{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, libxml2
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
}:

stdenv.mkDerivation rec {
  pname = "libgweather";
  version = "4.1.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "ALuJmOO5qQXzqNMpX8wVZS1rCc2l76Ik5nRN7Xq9plo=";
  };

  patches = [
    # Headers depend on glib but it is only listed in Requires.private,
    # which does not influence Cflags on non-static builds in nixpkgs’s
    # pkg-config. Let’s add it to Requires to ensure Cflags are set correctly.
    ./fix-pkgconfig.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    vala
    gi-docgen
    gobject-introspection
    python3
    python3.pkgs.pygobject3
  ];

  buildInputs = [
    glib
    libsoup_3
    libxml2
    geocode-glib_2
  ];

  mesonFlags = [
    "-Dzoneinfo_dir=${tzdata}/share/zoneinfo"
    "-Denable_vala=true"
    "-Dgtk_doc=true"
  ];

  postPatch = ''
    patchShebangs build-aux/meson/meson_post_install.py
    patchShebangs build-aux/meson/gen_locations_variant.py
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "A library to access weather information from online services for numerous locations";
    homepage = "https://wiki.gnome.org/Projects/LibGWeather";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
