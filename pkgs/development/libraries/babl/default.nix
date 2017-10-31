{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.34";

  src = fetchurl {
    url = "http://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "0nwakj313l2dh5npx18avkg4z17i2prkxbl6vj547a08n6ry1gsy";
  };

  meta = with stdenv.lib; { 
    description = "Image pixel format conversion library";
    homepage = http://gegl.org/babl/;
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
