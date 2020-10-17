{ stdenv
, fetchurl
, cmake
, gtest
, blas
, fftw
, liblapack
, gfortran
}:

stdenv.mkDerivation rec {
  pname = "it++";
  version = "4.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/itpp/itpp-${version}.tar.bz2";
    sha256 = "0xxqag9wi0lg78xgw7b40rp6wxqp5grqlbs9z0ifvdfzqlhpcwah";
  };

  nativeBuildInputs = [ cmake gfortran ];
  buildInputs = [
    fftw
    liblapack

    # NOTE: OpenBLAS doesn't work here because IT++ doesn't pass aligned
    # buffers, which causes segfaults in the optimized kernels :-(
    blas
  ];

  cmakeFlags = [
    "-DBLAS_FOUND:BOOL=TRUE"
    "-DBLAS_LIBRARIES:STRING=${blas}/lib/libblas.so"
    "-DLAPACK_FOUND:BOOL=TRUE"
    "-DLAPACK_LIBRARIES:STRING=${liblapack}/lib/liblapack.so"
    "-DGTEST_DIR:PATH=${gtest.src}/googletest"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  checkPhase = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD/itpp
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}$PWD/itpp
    ./gtests/itpp_gtests
  '';

  meta = with stdenv.lib; {
    description = "IT++ is a C++ library of mathematical, signal processing and communication classes and functions";
    homepage = http://itpp.sourceforge.net/;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ andrew-d ];
  };
}
