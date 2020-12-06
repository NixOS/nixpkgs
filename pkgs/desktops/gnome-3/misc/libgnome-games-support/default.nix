{ stdenv
, fetchurl
, pkgconfig
, glib
, gtk3
, libgee
, gettext
, vala
, gnome3
, libintl
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "libgnome-games-support";
  version = "1.8.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1pdk9hc30xdlv0ba24f7pvcr2d5370zykrmpws7hgmjgl4wfbpdb";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    libintl
  ];

  propagatedBuildInputs = [
    # Required by libgnome-games-support-1.pc
    glib
    gtk3
    libgee
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Small library intended for internal use by GNOME Games, but it may be used by others";
    homepage = "https://wiki.gnome.org/Apps/Games";
    license = licenses.lgpl3;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
