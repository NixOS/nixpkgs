{ lib, stdenv
, meson
, ninja
, gettext
, fetchurl
, evince
, gjs
, pkg-config
, gtk3
, glib
, tracker
, tracker-miners
, libxslt
, webkitgtk
, gnome-desktop
, libgepub
, gnome
, gdk-pixbuf
, gsettings-desktop-schemas
, adwaita-icon-theme
, docbook-xsl-nons
, docbook_xml_dtd_42
, desktop-file-utils
, python3
, gobject-introspection
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-books";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "0c41l8m2di8h39bmk2fnhpwglwp6qhljmwqqbihzp4ay9976zrc5";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    libxslt
    desktop-file-utils
    docbook-xsl-nons
    docbook_xml_dtd_42
    wrapGAppsHook
    python3
  ];

  buildInputs = [
    gtk3
    glib
    gsettings-desktop-schemas
    gdk-pixbuf
    adwaita-icon-theme
    evince
    webkitgtk
    gjs
    gobject-introspection
    tracker
    tracker-miners
    gnome-desktop
    libgepub
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-books";
      attrPath = "gnome.gnome-books";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Books";
    description = "An e-book manager application for GNOME";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
