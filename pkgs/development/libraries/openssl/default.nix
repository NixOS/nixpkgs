{stdenv, fetchurl, perl}: stdenv.mkDerivation {
  name = "openssl-0.9.7i";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.openssl.org/source/openssl-0.9.7i.tar.gz;
    sha1 = "f69d82b206ff8bff9d0e721f97380b9e";
  };
  buildInputs = [perl];
  patches = [./darwin-makefile.patch];
}
