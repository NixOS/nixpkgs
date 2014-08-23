{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mtdev-1.1.2";

  src = fetchurl {
    url = "http://bitmath.org/code/mtdev/${name}.tar.bz2";
    sha256 = "0c2sfxxymf20ylvblgmdmybqs0cydmphg9fq6fnp6flbl0fd33b9";
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

    license = stdenv.lib.licenses.mit;
  };
}
