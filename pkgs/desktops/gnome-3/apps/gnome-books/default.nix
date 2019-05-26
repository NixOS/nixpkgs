{ stdenv, meson, ninja, gettext, fetchurl, evince, gjs
, pkgconfig, gtk3, glib, tracker, tracker-miners, libxslt
, webkitgtk, gnome-desktop, libgepub, gnome3, gdk_pixbuf
, gsettings-desktop-schemas, adwaita-icon-theme, docbook_xsl
, docbook_xml_dtd_42, desktop-file-utils, python3
, gobject-introspection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "gnome-books";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1wkcywcwwszj9mldr0lngczqdz7hys08rr1nd2k6rs8ykzs2z7m4";
  };

  mesonFlags = [
    "--buildtype=plain"
  ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext libxslt desktop-file-utils
    docbook_xsl docbook_xml_dtd_42 wrapGAppsHook python3
  ];

  buildInputs = [
    gtk3 glib gsettings-desktop-schemas
    gdk_pixbuf adwaita-icon-theme evince
    webkitgtk gjs gobject-introspection tracker
    tracker-miners gnome-desktop libgepub
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
    homepage = https://wiki.gnome.org/Apps/Books;
    description = "An e-book manager application for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
