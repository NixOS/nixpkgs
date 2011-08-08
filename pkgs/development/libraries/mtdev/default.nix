{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "mtdev-1.1.0";

  src = fetchurl {
    url = "http://bitmath.org/code/mtdev/mtdev-1.1.0.tar.gz";
    sha256 = "14mky2vrzgy3x6k3rwkkpqkqyivbr6ym99gj5jmil9fqa9644lw4";
  };

  meta = {
    homepage = http://bitmath.org/code/mtdev/;

    description = "Multitouch Protocol Translation Library";

    longDescription = ''
      The mtdev is a stand-alone library which transforms all variants of
      kernel MT events to the slotted type B protocol. The events put into
      mtdev may be from any MT device, specifically type A without contact
      tracking, type A with contact tracking, or type B with contact tracking.
      See the kernel documentation for further details. 
    '';

    license = "MIT/X11";

    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}

