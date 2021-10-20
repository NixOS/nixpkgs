{ lib, stdenv
, fetchurl
, pkg-config
, glib
, gtk3
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
  version = "1.8.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0gs1k88wwafn5cdyb5yq1cxpi9azachb0ysxgwh15sx77g6plyy3";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
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
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Small library intended for internal use by GNOME Games, but it may be used by others";
    homepage = "https://wiki.gnome.org/Apps/Games";
    license = licenses.lgpl3;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
