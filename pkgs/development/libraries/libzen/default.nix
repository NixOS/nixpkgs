{ stdenv, fetchurl, automake, autoconf, libtool, pkgconfig }:

let version = "0.4.30"; in

stdenv.mkDerivation {
  name = "libzen-${version}";
  src = fetchurl {
    url = "http://mediaarea.net/download/source/libzen/${version}/libzen_${version}.tar.bz2";
    sha256 = "1ripvyzz2lw9nx2j8mkjgjfpabrz6knwxri52asqf1abnszbry64";
  };

  buildInputs = [ automake autoconf libtool pkgconfig ];
  configureFlags = [ "--enable-shared" ];

  sourceRoot = "./ZenLib/Project/GNU/Library/";

  preConfigure = "sh autogen";

  meta = {
    description = "Shared library for libmediainfo and mediainfo";
    homepage = http://mediaarea.net/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
