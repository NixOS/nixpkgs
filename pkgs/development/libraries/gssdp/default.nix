{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, gobject-introspection
, vala
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_412
, libsoup
, gtk3
, glib
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "gssdp";
  version = "1.2.3";

  outputs = [ "out" "bin" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gssdp/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1s57i8a8wnnxnsfl27cq4503dkdlzbrhry5zpg23sfqfffvdqqx2";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gobject-introspection
    vala
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
  ];

  buildInputs = [
    libsoup
    gtk3
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "GObject-based API for handling resource discovery and announcement over SSDP";
    homepage = "http://www.gupnp.org/";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
  };
}
