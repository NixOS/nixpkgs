{ lib, stdenv, fetchurl, pkg-config, gnome, gtk3, wrapGAppsHook
, librsvg, gettext, itstool, libxml2
, meson, ninja, glib, vala, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "gnome-mahjongg";
  version = "3.38.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mahjongg/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "144ia3zn9rhwa1xbdkvsz6m0dsysl6mxvqw9bnrlh845hmyy9cfj";
  };

  nativeBuildInputs = [
    meson ninja vala desktop-file-utils
    pkg-config gnome.adwaita-icon-theme
    libxml2 itstool gettext wrapGAppsHook
    glib # for glib-compile-schemas
  ];
  buildInputs = [
    glib
    gtk3
    librsvg
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Mahjongg";
    description = "Disassemble a pile of tiles by removing matching pairs";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
