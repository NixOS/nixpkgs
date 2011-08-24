{ stdenv, fetchurl, pkgconfig, intltool, glib }:

stdenv.mkDerivation rec {
  name = "garcon-0.1.8";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/garcon/0.1/${name}.tar.bz2";
    sha1 = "e5eac6a13208c81ccad0941656c01e7a69530f03";
  };

  buildInputs = [ pkgconfig intltool glib ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Xfce menu support library";
    license = "GPLv2+";
  };
}
