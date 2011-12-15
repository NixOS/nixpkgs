{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babl-0.1.4";

  src = fetchurl {
    url = "http://ftp.snt.utwente.nl/pub/software/gimp/babl/0.1/${name}.tar.bz2";
    sha256 = "0cz7zw206bb87c0n0h54h4wlkaa3hx3wsia30mgq316y50jk2djv";
  };

  meta = { 
    description = "Image pixel format conversion library";
    homepage = http://gegl.org/babl/;
    license = "GPL3";
  };
}
