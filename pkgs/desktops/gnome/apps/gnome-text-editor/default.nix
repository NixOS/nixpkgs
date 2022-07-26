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
, enchant
, icu
, itstool
, libadwaita
, libxml2
, pcre
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "gnome-text-editor";
  version = "42.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-text-editor/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-5W1KjNy86KjxwIgbRd55n4slIF7Ay/ImnlMgJXYcxdo=";
  };

  nativeBuildInputs = [
    appstream-glib
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
    enchant
    icu
    glib
    gsettings-desktop-schemas
    gtk4
    gtksourceview5
    libadwaita
    pcre
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-text-editor";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-text-editor";
    description = "A Text Editor for GNOME";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
