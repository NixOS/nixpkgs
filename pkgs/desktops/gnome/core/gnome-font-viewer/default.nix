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
, wrapGAppsHook4
, gnome
, harfbuzz
}:

stdenv.mkDerivation rec {
  pname = "gnome-font-viewer";
  version = "42.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-font-viewer/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "aNUBFJ63k+T8a7lqnYZZdja98Q6eKCA+LmT2QUPNSmk=";
  };

  doCheck = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    wrapGAppsHook4
    libxml2
  ];

  buildInputs = [
    gtk4
    glib
    gnome-desktop
    harfbuzz
    libadwaita
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
    platforms = platforms.linux;
  };
}
