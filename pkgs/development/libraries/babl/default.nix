{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.12";

  src = fetchurl {
    url = "http://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "01x4an6zixrhn0vibkxpcb7gg348gadydq8gpw82rdqp39zjp01g";
  };

  meta = { 
    description = "Image pixel format conversion library";
    homepage = http://gegl.org/babl/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
  };
}
