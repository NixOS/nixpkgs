{stdenv, fetchurl, openssl, cyrus_sasl, db4, groff}:

stdenv.mkDerivation rec {
  name = "openldap-2.4.34";

  src = fetchurl {
    url = "ftp://ftp.nl.uu.net/pub/unix/db/openldap/openldap-release/${name}.tgz";
    sha256 = "01h6zq6zki9b1k07pbyps5vxj9w39ybzjvkyz5h9xk09dd54raza";
  };

  buildInputs = [openssl cyrus_sasl db4 groff];

  dontPatchELF = 1; # !!!

  meta = {
    homepage = "http://www.openldap.org/";
    description = "An open source implementation of the Lightweight Directory Access Protocol";
  };
}
