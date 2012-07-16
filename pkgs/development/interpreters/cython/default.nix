{ stdenv, fetchurl, python, pkgconfig }:

stdenv.mkDerivation {
  name = "cython-0.16";

  src = fetchurl {
    url = http://www.cython.org/release/Cython-0.16.tar.gz;
    sha256 = "1yz6jwv25xx5mbr2nm4l7mi65gvpm63dzi3vrw73p51wbpy525lp";
  };

  buildPhase = "python setup.py build --build-base $out";

  installPhase = "python setup.py install --prefix=$out";

  buildInputs = [ python pkgconfig ];

  meta = {
    description = "An interpreter to help writing C extensions for Python";
  };
}
