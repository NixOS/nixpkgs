{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "openssl-0.9.8h";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/security/openssl/openssl-0.9.8h.tar.gz;
    sha1 = "ced4f2da24a202e01ea22bef30ebc8aee274de86";
  };
  buildInputs = [perl];
}
