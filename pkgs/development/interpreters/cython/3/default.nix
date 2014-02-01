{ stdenv, fetchurl, python3, pkgconfig }:

stdenv.mkDerivation {
  name = "cython3-0.20";

  src = fetchurl {
    url = http://www.cython.org/release/Cython-0.20.tar.gz;
    sha256 = "1a3m7zhw8mdyr95fwx7n1scrz82drr433i99dzm1n9dxi0cx2qah";
  };

  buildPhase = "python3 setup.py build --build-base $out";

  installPhase = "python3 setup.py install --prefix=$out";

  buildInputs = [ python3 pkgconfig ];

  meta = {
    description = "An interpreter to help writing C extensions for Python3";
    platforms = stdenv.lib.platforms.all;
  };
}
