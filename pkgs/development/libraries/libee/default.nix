{ stdenv, fetchurl, pkgconfig, libestr }:
stdenv.mkDerivation {
  name = "libee-0.4.1";

  src = fetchurl {
    url = http://www.libee.org/download/files/download/libee-0.4.1.tar.gz;
    md5 = "7bbf4160876c12db6193c06e2badedb2";
  };

  buildInputs = [pkgconfig libestr];

  meta = {
    homepage = "http://www.libee.org/";
    description = "An Event Expression Library inspired by CEE";
  };
}
