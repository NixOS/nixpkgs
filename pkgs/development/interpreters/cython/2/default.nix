{ stdenv, fetchurl, python, pkgconfig }:

stdenv.mkDerivation {
  name = "cython-0.20";

  src = fetchurl {
    url = http://www.cython.org/release/Cython-0.20.tar.gz;
    sha256 = "1a3m7zhw8mdyr95fwx7n1scrz82drr433i99dzm1n9dxi0cx2qah";
  };

  buildPhase = "python setup.py build --build-base $out";

  installPhase = "python setup.py install --prefix=$out";

  buildInputs = [ python pkgconfig ];

  meta = {
    description = "An interpreter to help writing C extensions for Python 2";
    platforms = stdenv.lib.platforms.all;
  };
}
