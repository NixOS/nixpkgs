{ stdenv
, fetchFromGitHub
, gfortran
, blas, lapack
, metis
, fixDarwinDylibNames
, gnum4
, enableCuda ? false
, cudatoolkit
}:

stdenv.mkDerivation rec {
  pname = "suitesparse";
  version = "5.7.2";

  outputs = [ "out" "dev" "doc" ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "SuiteSparse";
    rev = "v${version}";
    sha256 = "1imndff7yygjrbbrcscsmirdi8w0lkwj5dbhydxmf7lklwn4j3q6";
  };

  nativeBuildInputs = [
    gnum4
  ] ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  buildInputs = [
    blas lapack
    metis
    gfortran.cc.lib
  ] ++ stdenv.lib.optional enableCuda cudatoolkit;

  preConfigure = ''
    # Mongoose and GraphBLAS are packaged separately
    sed -i "Makefile" -e '/GraphBLAS\|Mongoose/d'
  '';

  makeFlags = [
    "INSTALL=${placeholder "out"}"
    "INSTALL_INCLUDE=${placeholder "dev"}/include"
    "JOBS=$(NIX_BUILD_CORES)"
    "BLAS=-lblas"
    "LAPACK=-llapack"
    "MY_METIS_LIB=-lmetis"
  ] ++ stdenv.lib.optionals blas.isILP64 [
    "CFLAGS=-DBLAS64"
  ] ++ stdenv.lib.optionals enableCuda [
    "CUDA_PATH=${cudatoolkit}"
    "CUDART_LIB=${cudatoolkit.lib}/lib/libcudart.so"
    "CUBLAS_LIB=${cudatoolkit}/lib/libcublas.so"
  ];

  buildFlags = [
    # Build individual shared libraries, not demos
    "library"
  ];

  meta = with stdenv.lib; {
    homepage = "http://faculty.cse.tamu.edu/davis/suitesparse.html";
    description = "A suite of sparse matrix algorithms";
    license = with licenses; [ bsd2 gpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ ttuegel ];
    platforms = with platforms; unix;
  };
}
