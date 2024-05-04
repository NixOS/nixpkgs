{ lib
, stdenv
, fetchurl
, meson
, ninja
, vala
, pkg-config
, desktop-file-utils
, wrapGAppsHook4
, gobject-introspection
, gettext
, itstool
, libxml2
, gnome
, glib
, gtk4
, libadwaita
, librsvg
, pango
}:

stdenv.mkDerivation rec {
  pname = "gnome-chess";
  version = "46.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-chess/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-oryQ4KdUMSxXibkZi0knMDd1tiWDqOlnbSxqlztG/ec=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    gettext
    itstool
    libxml2
    desktop-file-utils
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    librsvg
    pango
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-chess";
      attrPath = "gnome.gnome-chess";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-chess";
    description = "Play the classic two-player boardgame of chess";
    mainProgram = "gnome-chess";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
