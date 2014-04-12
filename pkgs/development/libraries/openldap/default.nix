{stdenv, fetchurl, openssl, cyrus_sasl, db, groff}:

stdenv.mkDerivation rec {
  name = "openldap-2.4.39";

  src = fetchurl {
    url = "http://www.openldap.org/software/download/OpenLDAP/openldap-release/${name}.tgz";
    sha256 = "19zq9dc7dl03wmqd11fbsdii1npyq1vlicl3nxbfygqh8xrwhrw2";
  };

  buildInputs = [ openssl cyrus_sasl db groff ];

  configureFlags =
    [ "--enable-overlays"
      "--disable-dependency-tracking"   # speeds up one-time build
    ] ++ stdenv.lib.optional (openssl == null) "--without-tls"
      ++ stdenv.lib.optional (cyrus_sasl == null) "--without-cyrus-sasl";

  meta = with stdenv.lib; {
    homepage    = http://www.openldap.org/;
    description = "An open source implementation of the Lightweight Directory Access Protocol";
    maintainers = with maintainers; [ lovek323 mornfall ];
    platforms   = platforms.unix;
  };
}
