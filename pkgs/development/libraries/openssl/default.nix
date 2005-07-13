{stdenv, fetchurl, perl}: stdenv.mkDerivation {
  name = "openssl-0.9.7g";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.openssl.org/source/openssl-0.9.7g.tar.gz;
    md5 = "991615f73338a571b6a1be7d74906934";
  };
  buildInputs = [perl];
}
