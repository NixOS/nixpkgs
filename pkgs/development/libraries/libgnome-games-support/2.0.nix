{ stdenv
, lib
, fetchurl
, pkg-config
, glib
, gobject-introspection
, gtk4
, libgee
, gettext
, vala
, gnome
, libintl
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "libgnome-games-support";
  version = "2.0.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "U4Ifb+Mu3cue7zMk9kaqrIPMbT3gk339XyZkcNRT0qQ=";
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
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
