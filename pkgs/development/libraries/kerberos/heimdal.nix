{stdenv, fetchurl, openldap, readline, db4, openssl, cyrus_sasl} :

stdenv.mkDerivation rec {
  name = "heimdal-1.3.2";

  src = fetchurl {
    urls = [
      "http://www.h5l.org/dist/src/${name}.tar.gz"
      "http://ftp.pdc.kth.se/pub/heimdal/src/${name}.tar.gz"
    ];
    sha256 = "0qwcq79nffsv9iyz4cf854l85i3x1cq79rxb34prpmjbfvs3ynwn";
  };

  ## ugly, X should be made an option
  configureFlags = "--with-openldap=${openldap} --without-x";
  
  propagatedBuildInputs = [ readline db4 openssl openldap cyrus_sasl ];
}
