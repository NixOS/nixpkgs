{ stdenv, fetchurl, openldap, readline, db4, openssl, cyrus_sasl, sqlite} :

stdenv.mkDerivation rec {
  name = "heimdal-1.3.3";

  src = fetchurl {
    urls = [
      "http://www.h5l.org/dist/src/${name}.tar.gz"
      "http://ftp.pdc.kth.se/pub/heimdal/src/${name}.tar.gz"
    ];
    sha256 = "0c465by1g7niy3nkfs5mwrm6j6w2cvrf4988h3lpmj194lkjp3cc";
  };

  patches = [ ./no-md2.patch ];
  
  ## ugly, X should be made an option
  configureFlags = [
    "--with-openldap=${openldap}"
    "--with-sqlite3=${sqlite}"
    "--without-x"
  ];
  # dont succeed with --libexec=$out/sbin, so
  postInstall = ''
    mv $out/libexec/* $out/sbin/
    rmdir $out/libexec
  '';

  propagatedBuildInputs = [ readline db4 openssl openldap cyrus_sasl sqlite];
}
