{ stdenv, fetchurl, openldap, readline, db4, openssl, cyrus_sasl, sqlite} :

stdenv.mkDerivation rec {
  name = "heimdal-1.5.2";

  src = fetchurl {
    urls = [
      "http://www.h5l.org/dist/src/${name}.tar.gz"
      "http://ftp.pdc.kth.se/pub/heimdal/src/${name}.tar.gz"
    ];
    sha256 = "22603f282f31173533b939d289f3374258aa1ccccbe51ee088d7568d321279ec";
  };

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
