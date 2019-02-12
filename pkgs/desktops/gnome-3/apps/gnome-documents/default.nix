{ stdenv, meson, ninja, gettext, fetchurl, evince, gjs
, pkgconfig, gtk3, glib, tracker, tracker-miners
, itstool, libxslt, webkitgtk, libgdata
, gnome-desktop, libzapojit, libgepub
, gnome3, gdk_pixbuf, libsoup, docbook_xsl, docbook_xml_dtd_42
, gobject-introspection, inkscape, poppler_utils
, desktop-file-utils, wrapGAppsHook, python3 }:

stdenv.mkDerivation rec {
  pname = "gnome-documents";
  version = "3.30.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-documents/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1z8gkfi2wyyd3bbv73rcdzi1gzaaaskabyscmbj51prayiw106b6";
  };

  doCheck = true;

  mesonFlags = [
    "-Dgetting_started=true"
    "-Dno_network=true"
  ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext itstool libxslt desktop-file-utils docbook_xsl docbook_xml_dtd_42 wrapGAppsHook python3
    inkscape poppler_utils # building getting started
  ];
  buildInputs = [
    gtk3 glib gnome3.gsettings-desktop-schemas
    gdk_pixbuf gnome3.defaultIconTheme evince
    libsoup webkitgtk gjs gobject-introspection
    tracker tracker-miners libgdata
    gnome-desktop libzapojit libgepub
  ];

  # Don't try to keep git submodules in sync for build
  patches = [
    ./no-network-option.patch
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
