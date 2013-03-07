{ stdenv, fetchurl_gnome, pkgconfig, gtk, intltool, libart_lgpl, libglade }:

stdenv.mkDerivation rec {
  name = src.pkgname;
  
  src = fetchurl_gnome {
    project = "libgnomecanvas";
    major = "2"; minor = "30"; patchlevel = "3";
    sha256 = "0h6xvswbqspdifnyh5pm2pqq55yp3kn6yrswq7ay9z49hkh7i6w5";
  };
  
  buildInputs = [ libglade ];
  nativeBuildInputs = [ pkgconfig intltool ];
  propagatedBuildInputs = [ libart_lgpl gtk ];
}
