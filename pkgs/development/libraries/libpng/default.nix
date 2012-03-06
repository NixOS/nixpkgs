{ stdenv, fetchurl, zlib }:

assert zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.5.9";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.xz";
    sha256 = "0rd0kn7bpdhbv4gw6475plc51a4p5kzk26kag0d08wfvb7ip8wxq";
  };

  propagatedBuildInputs = [ zlib ];

  passthru = { inherit zlib; };

  meta = {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
  };
}
