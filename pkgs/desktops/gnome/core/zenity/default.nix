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
  version = "3.42.1";

  src = fetchurl {
    url = "mirror://gnome/sources/zenity/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "oI4MjmJmFe4sI/90Yo66b4tIaHXdVDccp+LXYFtyqHw=";
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
