{ stdenv, fetchurl, fixedPoint ? false }:

stdenv.mkDerivation rec {
  name = "libopus-1.0.2";
  
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/opus-1.0.2.tar.gz";
    sha256 = "12npbkrcwvh3fl9l18cwrxwg269cg2j6j7876cc9q0axxvdmwqfs";
  };

  configureFlags = stdenv.lib.optionalString fixedPoint "--enable-fixed-point";

  meta = {
    description = "Open, royalty-free, highly versatile audio codec";
    license = "BSD";
    homepage = http://www.opus-codec.org/;
  };
}
