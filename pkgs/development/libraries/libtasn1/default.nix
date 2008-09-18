{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libtasn1-1.5";
  
  src = fetchurl {
    url = mirror://gnu/gnutls/libtasn1-1.5.tar.gz;
    sha256 = "1p4m9in144ypk6ndqw46sfz0njx6wccp0zlxjvigxry8034zbn6s";
  };

  meta = {
    homepage = http://josefsson.org/libtasn1/;
    description = "An ASN.1 library";
  };
}
