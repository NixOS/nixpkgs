{ stdenv, meson, ninja, gettext, fetchurl, evince, gjs
, pkgconfig, gtk3, glib, tracker, tracker-miners
, itstool, libxslt, webkitgtk, libgdata
, gnome-desktop, libzapojit, libgepub
, gnome3, gdk-pixbuf, libsoup, docbook_xsl, docbook_xml_dtd_42
, gobject-introspection, inkscape, poppler_utils
, desktop-file-utils, wrapGAppsHook, python3, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  pname = "gnome-documents";
  version = "3.33.90";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-documents/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0l9g10i380bnjp1y3pslsy8ph1hd5x1d57dadvq70p5ki4r3qjaw";
  };

  doCheck = true;

  mesonFlags = [
    "-Dgetting-started=true"
  ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext itstool libxslt desktop-file-utils docbook_xsl docbook_xml_dtd_42 wrapGAppsHook python3
    inkscape poppler_utils # building getting started
  ];
  buildInputs = [
    gtk3 glib gsettings-desktop-schemas
    gdk-pixbuf gnome3.adwaita-icon-theme evince
    libsoup webkitgtk gjs gobject-introspection
    tracker tracker-miners libgdata
    gnome-desktop libzapojit libgepub
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  preFixup = ''
    substituteInPlace $out/bin/gnome-documents --replace gapplication "${glib.bin}/bin/gapplication"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-documents";
      attrPath = "gnome3.gnome-documents";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Documents;
    description = "Document manager application designed to work with GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
