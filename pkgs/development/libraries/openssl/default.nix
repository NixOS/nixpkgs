{stdenv, fetchurl, perl}: stdenv.mkDerivation {
  name = "openssl-0.9.7g";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.openssl.org/source/openssl-0.9.7h.tar.gz;
    sha1 = "9fe535fce89af967b29c4727dedd25f2b4cc2f0d";
  };
  buildInputs = [perl];
  patches = [./darwin-makefile.patch];
}
