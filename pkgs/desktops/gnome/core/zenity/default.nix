{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, libxml2
, gnome
, gtk3
, gettext
, libX11
, itstool
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "zenity";
  version = "3.43.0";

  src = fetchurl {
    url = "mirror://gnome/sources/zenity/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sNfKHgwYaPoY8FwhAmDYp74fCO4Tt/XP26ubYfoW+DM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    libxml2
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libX11
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
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
