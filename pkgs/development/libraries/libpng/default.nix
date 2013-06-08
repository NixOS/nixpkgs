{ stdenv, fetchurl, zlib }:

assert zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.5.13";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.xz";
    sha256 = "1vks4mqv4140b10kp53qrywsx9m4xan5ibwsrlmf42ni075zjhxq";
  };

  propagatedBuildInputs = [ zlib ];

  passthru = { inherit zlib; };

  meta = {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
  };
}
