{ lib
, stdenv
, meson
, fetchurl
, python3
, pkg-config
, gtk4
, glib
, gtksourceview5
, gsettings-desktop-schemas
, wrapGAppsHook4
, ninja
, gnome
, cairo
, enchant
, icu
, itstool
, libadwaita
, editorconfig-core-c
, libxml2
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "gnome-text-editor";
  version = "46.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-text-editor/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-AFtIEEqQm+Zq4HRI0rxXBsfRE3gQV6JP9tpVvfMkxz0=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    itstool
    libxml2 # for xmllint
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    enchant
    icu
    glib
    gsettings-desktop-schemas
    gtk4
    gtksourceview5
    libadwaita
    editorconfig-core-c
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-text-editor";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-text-editor";
    description = "Text Editor for GNOME";
    mainProgram = "gnome-text-editor";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
