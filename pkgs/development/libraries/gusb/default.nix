{ lib, stdenv, fetchurl, substituteAll, meson, ninja, pkg-config, gettext, gobject-introspection
, gtk-doc, docbook_xsl, docbook_xml_dtd_412, docbook_xml_dtd_44, python3
, glib, libusb1, vala, hwdata
}:

let
  pythonEnv = python3.pythonForBuild.withPackages(ps: with ps; [
    setuptools
  ]);
in
stdenv.mkDerivation rec {
  pname = "gusb";
  version = "0.3.10";

  outputs = [ "bin" "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "https://people.freedesktop.org/~hughsient/releases/libgusb-${version}.tar.xz";
    sha256 = "sha256-DrC5qw+LugxZYxyAnDe2Fu806zyOAAsLm3HPEeSTG9w=";
  };

  patches = [
    (substituteAll {
      src = ./fix-python-path.patch;
      python = "${pythonEnv}/bin/python3";
    })
  ];

  nativeBuildInputs = [
    meson ninja pkg-config gettext pythonEnv
    gtk-doc docbook_xsl docbook_xml_dtd_412 docbook_xml_dtd_44
    gobject-introspection vala
  ];
  buildInputs = [ glib ];

  propagatedBuildInputs = [ libusb1 ];

  mesonFlags = [
    "-Dusb_ids=${hwdata}/share/hwdata/usb.ids"
  ];

  doCheck = false; # tests try to access USB

  meta = with lib; {
    description = "GLib libusb wrapper";
    homepage = "https://github.com/hughsie/libgusb";
    license = licenses.lgpl21;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.unix;
  };
}
