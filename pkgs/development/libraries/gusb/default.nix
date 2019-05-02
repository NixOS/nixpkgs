{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, gobject-introspection
, gtk-doc, docbook_xsl, docbook_xml_dtd_412, docbook_xml_dtd_44
, glib, systemd, libusb1, vala, hwdata
}:
stdenv.mkDerivation rec {
  name = "gusb-${version}";
  version = "0.3.0";

  outputs = [ "bin" "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "https://people.freedesktop.org/~hughsient/releases/libgusb-${version}.tar.xz";
    sha256 = "1p4f6jdjw6zl986f93gzdjg2hdcn5dlz6rcckcz4rbmnk47rbryq";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gettext
    gtk-doc docbook_xsl docbook_xml_dtd_412 docbook_xml_dtd_44
    gobject-introspection vala
  ];
  buildInputs = [ systemd glib ];

  propagatedBuildInputs = [ libusb1 ];

  mesonFlags = [
    "-Dusb_ids=${hwdata}/share/hwdata/usb.ids"
  ];

  doCheck = false; # tests try to access USB

  meta = with stdenv.lib; {
    description = "GLib libusb wrapper";
    homepage = https://github.com/hughsie/libgusb;
    license = licenses.lgpl21;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.unix;
  };
}
