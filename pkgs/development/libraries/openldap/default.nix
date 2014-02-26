{stdenv, fetchurl, openssl, cyrus_sasl, db, groff}:

stdenv.mkDerivation rec {
  name = "openldap-2.4.38";

  src = fetchurl {
    url = "ftp://ftp.nl.uu.net/pub/unix/db/openldap/openldap-release/${name}.tgz";
    sha256 = "1l8zng86alhcmmmw09r1c4dzl7yvk6dy5fq9zia96pgck4srl848";
  };

  buildInputs = [ openssl cyrus_sasl db groff ];

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
