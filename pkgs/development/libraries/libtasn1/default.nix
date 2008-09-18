{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libtasn1-1.4";
  
  src = fetchurl {
    url = mirror://gnu/gnutls/libtasn1-1.4.tar.gz;
    sha256 = "15k14cl334cjdw6hbw3scdxm0pfv078kfq6bnz9ngyg4by1kgal4";
  };

  meta = {
    homepage = http://josefsson.org/libtasn1/;
    description = "An ASN.1 library";
  };
}
