args:
with args;
stdenv.mkDerivation {
  name = "cyrus-sasl-2.1.22";

  src = fetchurl {
    url = ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/cyrus-sasl-2.1.22.tar.gz;
    sha256 = "c69e3853f35b14ee2c3f6e876e42d880927258ff4678aa052e5f0853db209962";
  };
  configureFlags="--with-openssl=${openssl} --with-plugindir=\${out}/lib/sasl2 --with-configdir=\${out}/lib/sasl2";
  buildInputs = [ openssl db4 gettext ];
  patches = [ ./cyrus-sasl-2.1.22-bad-elif.patch ];
}
