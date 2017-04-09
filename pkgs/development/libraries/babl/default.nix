{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.24";

  src = fetchurl {
    url = "http://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "02wxyaa9kjfypmg31avp2dxh16sfx9701ww6dmp0ggz5vnng2as7";
  };

  meta = with stdenv.lib; { 
    description = "Image pixel format conversion library";
    homepage = http://gegl.org/babl/;
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
