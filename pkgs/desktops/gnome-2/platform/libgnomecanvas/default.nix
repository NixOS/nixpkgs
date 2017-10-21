{ stdenv, fetchurl, pkgconfig, gtk, intltool, libart_lgpl, libglade }:

stdenv.mkDerivation rec {
  name = "libgnomecanvas-${minVer}.3";
  minVer = "2.30";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnomecanvas/${minVer}/${name}.tar.bz2";
    sha256 = "0h6xvswbqspdifnyh5pm2pqq55yp3kn6yrswq7ay9z49hkh7i6w5";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ libglade ];
  nativeBuildInputs = [ pkgconfig intltool ];
  propagatedBuildInputs = [ libart_lgpl gtk ];
}
