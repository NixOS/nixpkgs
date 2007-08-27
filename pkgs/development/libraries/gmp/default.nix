{stdenv, fetchurl, m4}:

stdenv.mkDerivation {
  name = "gmp-4.2.1";
  src = fetchurl {
    url = mirror://gnu/gmp/gmp-4.2.1.tar.bz2;
    md5 = "091c56e0e1cca6b09b17b69d47ef18e3";
  };
  buildInputs = [m4];
  doCheck = true;
}
