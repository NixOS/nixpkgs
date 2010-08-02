{ stdenv, fetchurl, pkgconfig, glib, zlib }:

stdenv.mkDerivation rec {
  name = "gmime-2.2.26";
  
  src = fetchurl {
    url = "mirror://gnome/sources/gmime/2.2/${name}.tar.gz";
    sha256 = "16inhq6symym9n71kxcndjwrxs2xrz63idvy64yc486wlg54aqfc";
  };
  
  buildInputs = [ pkgconfig glib zlib ];

  meta = {
    homepage = http://spruce.sourceforge.net/gmime/;
    description = "A C/C++ library for manipulating MIME messages";
  };
}
