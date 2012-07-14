{stdenv, fetchurl, openssl, cyrus_sasl, db4, groff}:

stdenv.mkDerivation rec {
  name = "openldap-2.4.31";

  src = fetchurl {
    url = "ftp://ftp.nl.uu.net/pub/unix/db/openldap/openldap-release/${name}.tgz";
    sha256 = "bde845840df4794b869a6efd6a6b1086f80989038e4844b2e4d7d6b57b39c5b6";
  };

  buildInputs = [openssl cyrus_sasl db4 groff];

  dontPatchELF = 1; # !!!

  meta = {
    homepage = "http://www.openldap.org/";
    description = "An open source implementation of the Lightweight Directory Access Protocol";
  };
}
