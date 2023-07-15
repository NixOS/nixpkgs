{ lib
, stdenv
, fetchurl
, pkg-config
, gnome
, gtk3
, wrapGAppsHook
, librsvg
, gsound
, clutter-gtk
, gettext
, itstool
, vala
, libxml2
, libgee
, libgnome-games-support
, meson
, ninja
, desktop-file-utils
, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "gnome-nibbles";
  version = "3.38.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-nibbles/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "l1/eHYPHsVs5Lqx6NZFhKQ/IrrdgXBHnHO4MPDJrXmE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook
    gettext
    itstool
    libxml2
    desktop-file-utils
    hicolor-icon-theme
  ];

  buildInputs = [
    gtk3
    librsvg
    gsound
    clutter-gtk
    gnome.adwaita-icon-theme
    libgee
    libgnome-games-support
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-nibbles";
      attrPath = "gnome.gnome-nibbles";
    };
  };

  meta = with lib; {
    description = "Guide a worm around a maze";
    homepage = "https://wiki.gnome.org/Apps/Nibbles";
    license = licenses.gpl2;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
