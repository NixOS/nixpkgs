{ fetchurl, stdenv, meson, ninja, vala, gtk-doc, docbook_xsl, docbook_xml_dtd_412, pkgconfig, glib, gtk3, cairo, sqlite, gnome3
, clutter-gtk, libsoup, gobject-introspection /*, libmemphis */ }:

stdenv.mkDerivation rec {
  pname = "libchamplain";
  version = "0.12.19";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "191aid1qsfkab5whbzj2r3g63dpdgrwp5141mfywvqyvdhr2x11n";
  };

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [ meson ninja pkgconfig gobject-introspection vala gtk-doc docbook_xsl docbook_xml_dtd_412 ];

  buildInputs = [ sqlite libsoup ];

  propagatedBuildInputs = [ glib gtk3 cairo clutter-gtk ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dvapi=true"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/libchamplain;
    license = licenses.lgpl2Plus;

    description = "C library providing a ClutterActor to display maps";

    longDescription = ''
      libchamplain is a C library providing a ClutterActor to display
       maps.  It also provides a GTK widget to display maps in GTK
       applications.  Python and Perl bindings are also available.  It
       supports numerous free map sources such as OpenStreetMap,
       OpenCycleMap, OpenAerialMap, and Maps for free.
    '';

     maintainers = gnome3.maintainers;
     platforms = platforms.gnu ++ platforms.linux;  # arbitrary choice
  };
}
