{ stdenv, fetchurl, fixedPoint ? false }:

stdenv.mkDerivation rec {
  name = "libopus-1.0.3";
  
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/opus-1.0.3.tar.gz";
    sha256 = "175l7hv7d03c4iz60g185nqvwrabc39ksil0d7g07i6vjaf0h6hr";
  };

  configureFlags = stdenv.lib.optionalString fixedPoint "--enable-fixed-point";

  meta = {
    description = "Open, royalty-free, highly versatile audio codec";
    license = "BSD";
    homepage = http://www.opus-codec.org/;
  };
}
