{stdenv, fetchurl, perl}: stdenv.mkDerivation {
  name = "openssl-0.9.8e";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/security/openssl/openssl-0.9.8e.tar.gz;
    sha256 = "0h03lrj99d44w2zjcr1mj210aza9j09s7zb5g5q53g2zp4l88kj1";
  };
  buildInputs = [perl];
}
