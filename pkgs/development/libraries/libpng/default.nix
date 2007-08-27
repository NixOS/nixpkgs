{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation {
  name = "libpng-1.2.18";
  src = fetchurl {
    url = mirror://sourceforge/libpng/libpng-1.2.18.tar.bz2;
    sha256 = "0qhcy8r0r8280wahs91xi4p79gm2cb021x9bcww1r5bywvwn5kkg";
  };
  propagatedBuildInputs = [zlib];
  inherit zlib;
}
