{ stdenv, fetchurl, fixedPoint ? false }:

stdenv.mkDerivation rec {
  name = "libopus-1.0.1";
  
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/opus-1.0.1.tar.gz";
    sha256 = "1vs133z6c03xi1a7b8bkqxlb6ipwchawwb52z1lgvh1amwy5ryl0";
  };

  configureFlags = stdenv.lib.optionalString fixedPoint "--enable-fixed-point";

  meta = {
    description = "Open, royalty-free, highly versatile audio codec";
    license = "BSD";
    homepage = http://www.opus-codec.org/;
  };
}
