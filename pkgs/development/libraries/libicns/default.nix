{ stdenv, fetchurl, fetchpatch, autoreconfHook, libpng, openjpeg }:

stdenv.mkDerivation rec {
  pname = "libicns";
  version = "0.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/icns/${pname}-${version}.tar.gz";
    sha256 = "1hjm8lwap7bjyyxsyi94fh5817xzqhk4kb5y0b7mb6675xw10prk";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/libi/libicns/0.8.1-3.1/debian/patches/support-libopenjp2.patch";
      sha256 = "0ss298lyzvydxvaxsadi6kbbjpwykd86jw3za76brcsg2dpssgas";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libpng openjpeg ];
  NIX_CFLAGS_COMPILE = [ "-I${openjpeg.dev}/include/${openjpeg.incDir}" ];

  meta = with stdenv.lib; {
    description = "Library for manipulation of the Mac OS icns resource format";
    homepage = https://icns.sourceforge.io;
    license = with licenses; [ gpl2 lgpl2 lgpl21 ];
    platforms = platforms.unix;
  };
}
