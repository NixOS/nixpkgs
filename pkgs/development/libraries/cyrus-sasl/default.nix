{ stdenv, fetchurl, openssl, db4, gettext, automake} :

stdenv.mkDerivation {
  name = "cyrus-sasl-2.1.23";

  src = fetchurl {
    url = ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/cyrus-sasl-2.1.23.tar.gz;
    sha256 = "0dmi41hfy015pzks8n93qsshgvi0az7pv81nls4nxayb810crvr0";
  };
  preConfigure=''
    configureFlags="--with-openssl=${openssl} --with-plugindir=$out/lib/sasl2 --with-configdir=$out/lib/sasl2 --enable-login"
    cp ${automake}/share/automake*/config.{sub,guess} config
  '';
  buildInputs = [ openssl db4 gettext ];
  patches = [ ./cyrus-sasl-2.1.22-bad-elif.patch ];
}
