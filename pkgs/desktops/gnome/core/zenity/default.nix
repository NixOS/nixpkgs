{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, libxml2
, gnome
, gtk4
, gettext
, libadwaita
, itstool
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "zenity";
  version = "3.91.0";

  src = fetchurl {
    url = "mirror://gnome/sources/zenity/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "N2GeCYAwgXj9vPaDItmaB7MzbBwLuY7ysyycsQkCI5k=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    libxml2
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "zenity";
      attrPath = "gnome.zenity";
    };
  };

  meta = with lib; {
    description = "Tool to display dialogs from the commandline and shell scripts";
    homepage = "https://wiki.gnome.org/Projects/Zenity";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
