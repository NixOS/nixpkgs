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
  version = "2.0.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "grvHTwj5i4M6m2REuEeeG9hN7QoHQl0Fe0XzjoeD5b0=";
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
      packageName = "libgnome-games-support";
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
