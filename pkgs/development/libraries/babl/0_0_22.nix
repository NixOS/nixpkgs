{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "babl-0.0.22";

  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/babl/0.0/babl-0.0.22.tar.bz2;
    sha256 = "0v8gbf9si4sd06199f8lfmrsbvi6i0hxphd34kyvsj6g2kkkg10s";
  };

  meta = { 
    description = "Image pixel format conversion library";
    homepage = http://gegl.org/babl/;
    license = stdenv.lib.licenses.gpl3;
  };
}
