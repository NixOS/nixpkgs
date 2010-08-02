{ stdenv, fetchurl, qt4, dbus, zlib, openssl, readline, perl }:

stdenv.mkDerivation {
  name = "wvstreams-4.6.1";

  src = fetchurl {
    url = http://wvstreams.googlecode.com/files/wvstreams-4.6.1.tar.gz;
    sha256 = "0cvnq3mvh886gmxh0km858aqhx30hpyrfpg1dh6ara9sz3xza0w4";
  };

  preConfigure = ''
    find -type f | xargs sed -i 's@/bin/bash@bash@g'
  '';

  buildInputs = [ qt4 dbus zlib openssl readline perl ];

  meta = {
    description = "Network programming library in C++";
    homepage = http://alumnit.ca/wiki/index.php?page=WvStreams;
    license = "LGPL";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
