{ lib
, stdenv
, meson
, ninja
, gettext
, fetchurl
, pkg-config
, gtk4
, glib
, libxml2
, gnome-desktop
, libadwaita
, fribidi
, wrapGAppsHook4
, gnome
, harfbuzz
}:

stdenv.mkDerivation rec {
  pname = "gnome-font-viewer";
  version = "44.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-font-viewer/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "0Dhb3qjH9AYWx8Fyp0SnbaaaKgUWs8lug6abc50Il+0=";
  };

  doCheck = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    wrapGAppsHook4
    libxml2
    glib
  ];

  buildInputs = [
    gtk4
    glib
    gnome-desktop
    harfbuzz
    libadwaita
    fribidi
  ];

  # Do not run meson-postinstall.sh
  preConfigure = "sed -i '2,$ d'  meson-postinstall.sh";

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-font-viewer";
      attrPath = "gnome.gnome-font-viewer";
    };
  };

  meta = with lib; {
    description = "Program that can preview fonts and create thumbnails for fonts";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-font-viewer";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
