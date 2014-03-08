{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nasm-2.11.01";
  
  src = fetchurl {
    url = "http://www.nasm.us/pub/nasm/releasebuilds/2.11.01/${name}.tar.bz2";
    sha256 = "0p0rhq18in2hyv3gircgxj72n2b1mvr8bvjlqscpaz8m62cyvam7";
  };

  meta = {
    homepage = http://www.nasm.us/;
    description = "An 80x86 and x86-64 assembler designed for portability and modularity";
    platforms = stdenv.lib.platforms.linux;
  };
}
