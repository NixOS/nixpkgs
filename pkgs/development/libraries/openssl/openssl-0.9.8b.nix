{stdenv, fetchurl, perl}: stdenv.mkDerivation {
  name = "openssl-0.9.8b";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/security/openssl/openssl-0.9.8b.tar.gz;
    sha1 = "99565db630a044fa484d4f91006a31908f262246";
  };
  buildInputs = [perl];
}
