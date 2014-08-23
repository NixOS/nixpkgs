{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.10";

  src = fetchurl {
    url = "ftp://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
    sha256 = "943fc36ceac7dd25bc928256bc7b535a42989c6b971578146869eee5fe5955f4";
  };

  meta = { 
    description = "Image pixel format conversion library";
    homepage = http://gegl.org/babl/;
    license = stdenv.lib.licenses.gpl3;
  };
}
