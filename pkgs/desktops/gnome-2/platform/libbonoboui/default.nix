{ lib, stdenv, fetchurl, bison, pkg-config, popt, libxml2, gtk2, libtool
, intltool, libbonobo, GConf, libgnomecanvas, libgnome, libglade }:

stdenv.mkDerivation rec {
  pname = "libbonoboui";
  version = "2.24.5";

  src = fetchurl {
    url = "mirror://gnome/sources/libbonoboui/${lib.versions.majorMinor version}/libbonoboui-${version}.tar.bz2";
    sha256 = "1kbgqh7bw0fdx4f1a1aqwpff7gp5mwhbaz60c6c98bc4djng5dgs";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config intltool ];
  buildInputs = [ bison popt gtk2 libxml2 GConf libglade libtool ];
  propagatedBuildInputs = [ libbonobo libgnomecanvas libgnome ];
}
