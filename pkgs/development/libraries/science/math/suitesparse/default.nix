{ stdenv, fetchurl, gfortran, openblas, cmake, fixDarwinDylibNames
, enableCuda  ? false, cudatoolkit
}:

let
  version = "5.3.0";
  name = "suitesparse-${version}";

  SHLIB_EXT = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation rec {
  inherit name;

  src = fetchurl {
    url = "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-${version}.tar.gz";
    sha256 = "0gcn1xj3z87wpp26gxn11k8073bxv6jswfd8jmddlm64v09rgrlh";
  };

  dontUseCmakeConfigure = true;

  preConfigure = ''
    mkdir -p $out/lib
    mkdir -p $out/include
    mkdir -p $out/share/doc/${name}

    sed -i "SuiteSparse_config/SuiteSparse_config.mk" \
        -e 's/METIS .*$/METIS =/' \
        -e 's/METIS_PATH .*$/METIS_PATH =/' \
        -e '/CHOLMOD_CONFIG/ s/$/-DNPARTITION/'
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

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin " -DNTIMER";

  buildPhase = ''
    runHook preBuild

    # Build individual shared libraries
    make library        \
        BLAS=-lopenblas \
        LAPACK=""       \
        ${stdenv.lib.optionalString openblas.blas64 "CFLAGS=-DBLAS64"}

    # Build libsuitesparse.so which bundles all the individual libraries.
    # Bundling is done by building the static libraries, extracting objects from
    # them and combining the objects into one shared library.
    mkdir -p static
    make static AR_TARGET=$(pwd)/static/'$(LIBRARY).a'
    (
        cd static
        for i in lib*.a; do
          ar -x $i
        done
    )
    ${if enableCuda then "${cudatoolkit}/bin/nvcc" else "${stdenv.cc.outPath}/bin/cc"} \
        static/*.o                                                                     \
        ${if stdenv.isDarwin then "-dynamiclib" else "--shared"}                       \
        -o "lib/libsuitesparse${SHLIB_EXT}"                                            \
        -lopenblas                                                                     \
        ${stdenv.lib.optionalString enableCuda "-lcublas"}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r lib $out/
    cp -r include $out/
    cp -r share $out/

    # Fix rpaths
    cd $out
    find -name \*.so\* -type f -exec \
      patchelf --set-rpath "$out/lib:${stdenv.lib.makeLibraryPath buildInputs}" {} \;

    runHook postInstall
  '';

  nativeBuildInputs = [ cmake ]
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  buildInputs = [ openblas gfortran.cc.lib ]
    ++ stdenv.lib.optional enableCuda cudatoolkit;

  meta = with stdenv.lib; {
    homepage = http://faculty.cse.tamu.edu/davis/suitesparse.html;
    description = "A suite of sparse matrix algorithms";
    license = with licenses; [ bsd2 gpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ ttuegel ];
    platforms = with platforms; unix;
  };
}
