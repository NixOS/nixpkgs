{ fetchurl, stdenv, zlib, openssl, libuuid, pkgconfig }:

stdenv.mkDerivation rec {
  version = "20171104";
  pname = "libewf";

  src = fetchurl {
    url = "https://github.com/libyal/libewf/releases/download/${version}/libewf-experimental-${version}.tar.gz";
    sha256 = "0h7036gpj5cryvh17aq6i2cpnbpwg5yswmfydxbbwvd9yfxd6dng";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib openssl libuuid ];

  meta = {
    description = "Library for support of the Expert Witness Compression Format";
    homepage = "https://sourceforge.net/projects/libewf/";
    license = stdenv.lib.licenses.lgpl3;
    maintainers = [ stdenv.lib.maintainers.raskin ] ;
    platforms = stdenv.lib.platforms.unix;
    inherit version;
  };
}
