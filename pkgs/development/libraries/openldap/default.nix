{stdenv, fetchurl, openssl, cyrus_sasl, db4, groff}:

stdenv.mkDerivation rec {
  name = "openldap-2.4.35";

  src = fetchurl {
    url = "ftp://ftp.nl.uu.net/pub/unix/db/openldap/openldap-release/${name}.tgz";
    sha256 = "1swy3rly6y0asikp862sigmab8gcll6scb65ln10vps7q5s0640n";
  };

  buildInputs = [ openssl cyrus_sasl db4 groff ];

  configureFlags =
    [ "--enable-overlays"
    ] ++ stdenv.lib.optional (openssl == null) "--without-tls"
      ++ stdenv.lib.optional (cyrus_sasl == null) "--without-cyrus-sasl";

  dontPatchELF = 1; # !!!

  meta = {
    homepage = "http://www.openldap.org/";
    description = "An open source implementation of the Lightweight Directory Access Protocol";
    maintainers = stdenv.lib.maintainers.mornfall;
  };
}
