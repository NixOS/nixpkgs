{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mtdev-1.1.6";

  src = fetchurl {
    url = "http://bitmath.org/code/mtdev/${name}.tar.bz2";
    sha256 = "1q700h9dqcm3zl6c3gj0qxxjcx6ibw2c51wjijydhwdcm26v5mqm";
  };

  meta = with stdenv.lib; {
    homepage = http://bitmath.org/code/mtdev/;
    description = "Multitouch Protocol Translation Library";
    longDescription = ''
      The mtdev is a stand-alone library which transforms all variants of
      kernel MT events to the slotted type B protocol. The events put into
      mtdev may be from any MT device, specifically type A without contact
      tracking, type A with contact tracking, or type B with contact tracking.
      See the kernel documentation for further details.
    '';
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
