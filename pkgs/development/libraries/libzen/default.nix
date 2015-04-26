{ stdenv, fetchurl, automake, autoconf, libtool, pkgconfig }:

let version = "0.4.31"; in

stdenv.mkDerivation {
  name = "libzen-${version}";
  src = fetchurl {
    url = "http://mediaarea.net/download/source/libzen/${version}/libzen_${version}.tar.bz2";
    sha256 = "1d54bn561dipf16ki1bfq5r72j5bmz1yyx4n1v85jv4qc4cfvl4z";
  };

  buildInputs = [ automake autoconf libtool pkgconfig ];
  configureFlags = [ "--enable-shared" ];

  sourceRoot = "./ZenLib/Project/GNU/Library/";

  preConfigure = "sh autogen";

  meta = {
    description = "Shared library for libmediainfo and mediainfo";
    homepage = http://mediaarea.net/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
