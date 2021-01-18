{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, gobject-introspection
, gtk-doc, docbook_xsl, docbook_xml_dtd_412, docbook_xml_dtd_44, python3
, glib, systemd, libusb1, vala, hwdata
}:

let
  pythonEnv = python3.withPackages(ps: with ps; [
    setuptools
  ]);
in
stdenv.mkDerivation rec {
  pname = "gusb";
  version = "0.3.5";

  outputs = [ "bin" "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "https://people.freedesktop.org/~hughsient/releases/libgusb-${version}.tar.xz";
    sha256 = "1pv5ivbwxb9anq2j34i68r8fgs8nwsi4hmss7h9v1i3wk7300ajv";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gettext pythonEnv
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
    homepage = "https://github.com/hughsie/libgusb";
    license = licenses.lgpl21;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.unix;
  };
}
