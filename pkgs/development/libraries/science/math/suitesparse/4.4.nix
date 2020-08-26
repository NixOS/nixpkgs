{ stdenv, fetchurl, gfortran, blas, lapack
, enableCuda ? false, cudatoolkit
}:

let
  version = "4.4.4";
  name = "suitesparse-${version}";

  int_t = if blas.isILP64 then "int64_t" else "int32_t";
  SHLIB_EXT = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-${version}.tar.gz";
    sha256 = "1zdn1y0ij6amj7smmcslkqgbqv9yy5cwmbyzqc9v6drzdzllgbpj";
  };

  preConfigure = ''
    mkdir -p $out/lib
    mkdir -p $out/include

    sed -i "SuiteSparse_config/SuiteSparse_config.mk" \
        -e 's/METIS .*$/METIS =/' \
        -e 's/METIS_PATH .*$/METIS_PATH =/' \
        -e '/CHOLMOD_CONFIG/ s/$/-DNPARTITION -DLONGBLAS=${int_t}/' \
        -e '/UMFPACK_CONFIG/ s/$/-DLONGBLAS=${int_t}/'
  ''
  + stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i "SuiteSparse_config/SuiteSparse_config.mk" \
        -e 's/^[[:space:]]*\(LIB = -lm\) -lrt/\1/'
  ''
  + stdenv.lib.optionalString enableCuda ''
    sed -i "SuiteSparse_config/SuiteSparse_config.mk" \
        -e 's|^[[:space:]]*\(CUDA_ROOT     =\)|CUDA_ROOT = ${cudatoolkit}|' \
        -e 's|^[[:space:]]*\(GPU_BLAS_PATH =\)|GPU_BLAS_PATH = $(CUDA_ROOT)|' \
        -e 's|^[[:space:]]*\(GPU_CONFIG    =\)|GPU_CONFIG = -I$(CUDA_ROOT)/include -DGPU_BLAS -DCHOLMOD_OMP_NUM_THREADS=$(NIX_BUILD_CORES) |' \
        -e 's|^[[:space:]]*\(CUDA_PATH     =\)|CUDA_PATH = $(CUDA_ROOT)|' \
        -e 's|^[[:space:]]*\(CUDART_LIB    =\)|CUDART_LIB = $(CUDA_ROOT)/lib64/libcudart.so|' \
        -e 's|^[[:space:]]*\(CUBLAS_LIB    =\)|CUBLAS_LIB = $(CUDA_ROOT)/lib64/libcublas.so|' \
        -e 's|^[[:space:]]*\(CUDA_INC_PATH =\)|CUDA_INC_PATH = $(CUDA_ROOT)/include/|' \
        -e 's|^[[:space:]]*\(NV20          =\)|NV20 = -arch=sm_20 -Xcompiler -fPIC|' \
        -e 's|^[[:space:]]*\(NV30          =\)|NV30 = -arch=sm_30 -Xcompiler -fPIC|' \
        -e 's|^[[:space:]]*\(NV35          =\)|NV35 = -arch=sm_35 -Xcompiler -fPIC|' \
        -e 's|^[[:space:]]*\(NVCC          =\) echo|NVCC = $(CUDA_ROOT)/bin/nvcc|' \
        -e 's|^[[:space:]]*\(NVCCFLAGS     =\)|NVCCFLAGS = $(NV20) -O3 -gencode=arch=compute_20,code=sm_20 -gencode=arch=compute_30,code=sm_30 -gencode=arch=compute_35,code=sm_35 -gencode=arch=compute_60,code=sm_60|'
  '';

  makeFlags = [
    "PREFIX=\"$(out)\""
    "INSTALL_LIB=$(out)/lib"
    "INSTALL_INCLUDE=$(out)/include"
    "BLAS=-lblas"
    "LAPACK=-llapack"
  ];

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin " -DNTIMER";

  postInstall = ''
    # Build and install shared library
    (
        cd "$(mktemp -d)"
        for i in "$out"/lib/lib*.a; do
          ar -x $i
        done
        ${if enableCuda then cudatoolkit else stdenv.cc.outPath}/bin/${if enableCuda then "nvcc" else "cc"} *.o ${if stdenv.isDarwin then "-dynamiclib" else "--shared"} -o "$out/lib/libsuitesparse${SHLIB_EXT}" -lblas ${stdenv.lib.optionalString enableCuda "-lcublas"}
    )
    for i in umfpack cholmod amd camd colamd spqr; do
      ln -s libsuitesparse${SHLIB_EXT} "$out"/lib/lib$i${SHLIB_EXT}
    done

    # Install documentation
    outdoc=$out/share/doc/${name}
    mkdir -p $outdoc
    cp -r AMD/Doc $outdoc/amd
    cp -r BTF/Doc $outdoc/bft
    cp -r CAMD/Doc $outdoc/camd
    cp -r CCOLAMD/Doc $outdoc/ccolamd
    cp -r CHOLMOD/Doc $outdoc/cholmod
    cp -r COLAMD/Doc $outdoc/colamd
    cp -r CXSparse/Doc $outdoc/cxsparse
    cp -r KLU/Doc $outdoc/klu
    cp -r LDL/Doc $outdoc/ldl
    cp -r RBio/Doc $outdoc/rbio
    cp -r SPQR/Doc $outdoc/spqr
    cp -r UMFPACK/Doc $outdoc/umfpack
  '';

  nativeBuildInputs = [ gfortran ];
  buildInputs = [ blas lapack ];

  meta = with stdenv.lib; {
    homepage = "http://faculty.cse.tamu.edu/davis/suitesparse.html";
    description = "A suite of sparse matrix algorithms";
    license = with licenses; [ bsd2 gpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ ttuegel ];
    platforms = with platforms; unix;
  };
}
