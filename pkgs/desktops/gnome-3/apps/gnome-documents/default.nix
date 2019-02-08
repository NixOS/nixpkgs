{ stdenv, meson, ninja, gettext, fetchurl, fetchpatch, evince, gjs
, pkgconfig, gtk3, glib, tracker, tracker-miners
, itstool, libxslt, webkitgtk, libgdata
, gnome-desktop, libzapojit, libgepub
, gnome3, gdk_pixbuf, libsoup, docbook_xsl, docbook_xml_dtd_42
, gobject-introspection, inkscape, poppler_utils
, desktop-file-utils, wrapGAppsHook, python3 }:

stdenv.mkDerivation rec {
  name = "gnome-documents-${version}";
  version = "3.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-documents/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0zchkjpc9algmxrpj0f9i2lc4h1yp8z0h76vn32xa9jr46x4lsh6";
  };

  doCheck = true;

  mesonFlags = [ "-Dgetting-started=true" ];

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

  patches = [
    # fix RPATH to libgd
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-documents/commit/d18a92e0a940073ac766f609937539e4fc6cdbb7.patch";
      sha256 = "0s3mk8vrl1gzk93yvgqbnz44i27qw1d9yvvmnck3fv23phrxkzk9";
    })
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
