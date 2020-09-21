{ stdenv
, meson
, ninja
, gettext
, fetchurl
, evince
, gjs
, pkgconfig
, gtk3
, glib
, tracker_2
, tracker-miners-2
, libxslt
, webkitgtk
, gnome-desktop
, libgepub
, gnome3
, gdk-pixbuf
, gsettings-desktop-schemas
, adwaita-icon-theme
, docbook_xsl
, docbook_xml_dtd_42
, desktop-file-utils
, python3
, gobject-introspection
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-books";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "153vknqisjn5f105avzm933fsc3v0pjzzbwxlqxf8vjjksh1cmya";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gettext
    libxslt
    desktop-file-utils
    docbook_xsl
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
    tracker_2
    tracker-miners-2
    gnome-desktop
    libgepub
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-books";
      attrPath = "gnome3.gnome-books";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Books";
    description = "An e-book manager application for GNOME";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
