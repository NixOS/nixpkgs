{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  glib,
  gobject-introspection,
  gtk4,
  libgee,
  gettext,
  vala,
  gnome,
  libintl,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "libgnome-games-support";
  version = "2.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "AYbyXEiSyGx+rEOjB/wZ22lt9PGayn9U6DwiHfnZeQo=";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    libintl
  ];

  propagatedBuildInputs = [
    # Required by libgnome-games-support-2.pc
    glib
    gtk4
    libgee
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "${pname}_2_0";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Small library intended for internal use by GNOME Games, but it may be used by others";
    homepage = "https://gitlab.gnome.org/GNOME/libgnome-games-support";
    license = licenses.lgpl3Plus;
    teams = [ teams.gnome ];
    platforms = platforms.unix;
  };
}
