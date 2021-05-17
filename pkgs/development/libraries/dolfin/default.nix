{ stdenv
, lib
, fetchurl
, fetchpatch
# - Python Dependencies
, python3Packages
# Package Building
, pkg-config
, cmake
, boost
, eigen
, hdf5
, mpi
, scotch
, swig
, zlib
# Documentation Building
, doxygen
# Linear-Algebra
, blas, lapack, suitesparse
}:

stdenv.mkDerivation rec {
  pname = "dolfin";
  version = "2019.1.0";

  src = fetchurl {
    url = "https://bitbucket.org/fenics-project/dolfin/downloads/${pname}-${version}.tar.gz";
    sha256 = "0kbyi4x5f6j4zpasch0swh0ch81w2h92rqm1nfp3ydi4a93vky33";
  };

  patches = [
    (fetchpatch {
      name = "fix-double-prefix.patch";
      url = "https://bitbucket.org/josef_kemetmueller/dolfin/commits/328e94acd426ebaf2243c072b806be3379fd4340/raw";
      sha256 = "1zj7k3y7vsx0hz3gwwlxhq6gdqamqpcw90d4ishwx5ps5ckcsb9r";
    })
  ];

  propagatedBuildInputs = with python3Packages; [
    dijitso
    fiat
    numpy
    six
    ufl
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];

  buildInputs = [
    boost
    eigen
    hdf5
    mpi
    blas
    lapack
    scotch
    suitesparse
    swig
    zlib
  ] ++ (with python3Packages; [
    python
    dijitso
    ffc
    fiat
    numpy
    ply
    six
    sphinx
    sympy
    ufl
  ]);

  cmakeFlags = [
    "-DDOLFIN_CXX_FLAGS=-std=c++11"
    "-DDOLFIN_AUTO_DETECT_MPI=ON"
    "-DDOLFIN_ENABLE_CHOLMOD=ON"
    "-DDOLFIN_ENABLE_DOCS=ON"
    "-DDOLFIN_ENABLE_HDF5=ON"
    "-DDOLFIN_ENABLE_MPI=ON"
    "-DDOLFIN_ENABLE_SCOTCH=ON"
    "-DDOLFIN_ENABLE_UMFPACK=ON"
    "-DDOLFIN_ENABLE_ZLIB=ON"
    "-DDOLFIN_SKIP_BUILD_TESTS=ON" # Otherwise SCOTCH is not found
    # TODO: Enable the following features
    "-DDOLFIN_ENABLE_PARMETIS=OFF"
    "-DDOLFIN_ENABLE_PETSC=OFF"
    "-DDOLFIN_ENABLE_SLEPC=OFF"
    "-DDOLFIN_ENABLE_TRILINOS=OFF"
  ];

  installCheckPhase = ''
    source $out/share/dolfin/dolfin.conf
    make runtests -j$NIX_BUILD_CORES
  '';

  meta = with lib; {
    description = "The FEniCS Problem Solving Environment in Python and C++";
    homepage = "https://fenicsproject.org/";
    license = with licenses; [ lgpl3Plus ];
  };
}
