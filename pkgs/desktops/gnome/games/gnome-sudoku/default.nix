{ stdenv
, lib
, fetchurl
, meson
, ninja
, vala
, pkg-config
, gobject-introspection
, gettext
, gtk4
, gnome
, wrapGAppsHook4
, libadwaita
, libgee
, json-glib
, qqwing
, itstool
, libxml2
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "gnome-sudoku";
  version = "45.4";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-sudoku/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "edNZV6oWj0pWPmAW+5dQs1hlJgEkEVg4CkxLebdAAZ0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    gobject-introspection
    gettext
    itstool
    libxml2
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    libgee
    json-glib
    qqwing
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-sudoku";
      attrPath = "gnome.gnome-sudoku";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Sudoku";
    description = "Test your logic skills in this number grid puzzle";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
