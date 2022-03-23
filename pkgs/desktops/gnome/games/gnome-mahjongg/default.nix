{ stdenv
, lib
, fetchurl
, fetchpatch
, pkg-config
, gnome
, gtk3
, wrapGAppsHook
, librsvg
, gettext
, itstool
, libxml2
, meson
, ninja
, glib
, vala
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "gnome-mahjongg";
  version = "3.38.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mahjongg/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "144ia3zn9rhwa1xbdkvsz6m0dsysl6mxvqw9bnrlh845hmyy9cfj";
  };

  patches = [
    # Fix build with meson 0.61
    # data/meson.build:24:0: ERROR: Function does not take positional arguments.
    # data/meson.build:45:0: ERROR: Function does not take positional arguments.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-mahjongg/-/commit/a2037b0747163601a5d5b57856d037eecf3a4db7.patch";
      sha256 = "Wcder6Y9H6c1f8I+IPDvST3umaCU21HgxfXn809JDz0=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    vala
    desktop-file-utils
    pkg-config
    gnome.adwaita-icon-theme
    libxml2
    itstool
    gettext
    wrapGAppsHook
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
