{ fetchurl, stdenv, zlib, openssl, libuuid, file, fuse }:

stdenv.mkDerivation rec {
  version = "20140608";
  name = "libewf-${version}";
  src = fetchurl {
    url = "https://googledrive.com/host/0B3fBvzttpiiSMTdoaVExWWNsRjg/libewf-20140608.tar.gz";
    sha256 = "0wfsffzxk934hl8cpwr14w8ixnh8d23x0xnnzcspjwi2c7730h6i";
  };

  preConfigure = ''sed -e 's@/usr/bin/file@file@g' -i configure'';

  buildInputs = [ zlib openssl libuuid ];

  meta = {
    description = "Library for support of the Expert Witness Compression Format";
    homepage = http://sourceforge.net/projects/libewf/;
    license = stdenv.lib.licenses.lgpl3;
    maintainers = [ stdenv.lib.maintainers.raskin ] ;
    inherit version;
  };
}
