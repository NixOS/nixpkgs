args:
with args;
stdenv.mkDerivation {
  name = "cyrus-sasl-2.1.23";

  src = fetchurl {
    url = ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/cyrus-sasl-2.1.23.tar.gz;
    sha256 = "0dmi41hfy015pzks8n93qsshgvi0az7pv81nls4nxayb810crvr0";
  };
  configureFlags="--with-openssl=${openssl} --with-plugindir=\${out}/lib/sasl2 --with-configdir=\${out}/lib/sasl2";
  buildInputs = [ openssl db4 gettext ];
}
