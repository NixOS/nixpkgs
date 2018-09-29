{ stdenv
, fetchurl
, gfortran
, cmake
, blas
, liblapack
, mpi
}:

stdenv.mkDerivation rec {
  name = "scalapack-${version}";
  version = "2.0.2";

  src = fetchurl {
    url = "http://www.netlib.org/scalapack/scalapack-${version}.tgz";
    sha256 = "0p1r61ss1fq0bs8ynnx7xq4wwsdvs32ljvwjnx6yxr8gd6pawx0c";
  };

  buildInputs = [ cmake mpi liblapack blas gfortran ];

  meta = with stdenv.lib; {
    homepage = http://www.netlib.org/scalapack/;
    description = "Library of high-performance linear algebra routines for parallel distributed memory machines";
    license = licenses.bsdOriginal;
    platforms = platforms.all;
    maintainers = [ maintainers.costrouc ];
  };

}
