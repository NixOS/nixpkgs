{ lib, stdenv
, fetchFromGitHub
, cmake
, gfortran
, blas, lapack
, metis
, fixDarwinDylibNames
, gmp
, mpfr
, config
, enableCuda ? config.cudaSupport
, cudatoolkit
}:

stdenv.mkDerivation rec {
  pname = "suitesparse";
  version = "7.0.1";

  outputs = [ "out" "dev" "doc" ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "SuiteSparse";
    rev = "v${version}";
    hash = "sha256-EIreweeOx44YDxlnxnJ7l31Ie1jSx6y87VAyEX+4NsQ=";
  };

  nativeBuildInputs = [
    cmake
  ] ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  # Use compatible indexing for lapack and blas used
  buildInputs = assert (blas.isILP64 == lapack.isILP64); [
    blas lapack
    metis
    gfortran.cc.lib
    gmp
    mpfr
  ] ++ lib.optional enableCuda cudatoolkit;

  propagatedBuildInputs = [
    gmp
    mpfr
  ];

  preConfigure = ''
    # Mongoose and GraphBLAS are packaged separately
    sed -i "Makefile" -e '/GraphBLAS\|Mongoose/d'
  '';

  FC = "${gfortran}/bin/gfortran";

  dontUseCmakeConfigure = true;

  cmakeFlags = [
    "-DBLA_VENDOR=Generic"
    # Definitions from CMake's setup hook
    # Unfortunately, it is not possible to extract the additional cmakeFlags generated there
    "-DCMAKE_INSTALL_BINDIR=${placeholder "out"}/bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=${placeholder "dev"}/include"
    "-DCMAKE_INSTALL_LIBDIR=${placeholder "out"}/lib"
  ] ++ lib.optionals blas.isILP64 [
    "-DALLOW_64BIT_BLAS=ON"
  ];

  # CMAKE_OPTIONS will be picked up via the Makefile
  CMAKE_OPTIONS = lib.concatStringsSep " "cmakeFlags;

  makeFlags = [
    "JOBS=$(NIX_BUILD_CORES)"
  ] ++ lib.optionals enableCuda [
    "CUDA_PATH=${cudatoolkit}"
    "CUDART_LIB=${cudatoolkit.lib}/lib/libcudart.so"
    "CUBLAS_LIB=${cudatoolkit}/lib/libcublas.so"
  ] ++ lib.optionals stdenv.isDarwin [
    # Unless these are set, the build will attempt to use `Accelerate` on darwin, see:
    # https://github.com/DrTimothyAldenDavis/SuiteSparse/blob/v5.13.0/SuiteSparse_config/SuiteSparse_config.mk#L368
    #"BLAS=-lblas"
    #"LAPACK=-llapack"
  ];

  env = lib.optionalAttrs stdenv.isDarwin {
    # Ensure that there is enough space for the `fixDarwinDylibNames` hook to
    # update the install names of the output dylibs.
    NIX_LDFLAGS = "-headerpad_max_install_names";
  };

  buildFlags = [
    # Build individual shared libraries, not demos
    "library"
    "docs"
  ];

  postInstall = ''
    mkdir -p $doc
    for docdir in */Doc; do
      local name="$(dirname "$docdir")"
      local dest_dir="$doc/share/doc/$name"

      if [[ $name = Mongoose || $name = GraphBLAS ]]; then
        # Mongoose and GraphBLAS are packaged separately
        continue
      fi

      echo "installing docs from $docdir to $dest_dir"
      install -Dt "$dest_dir" "$docdir/"*.{txt,pdf}
    done
    '';

  meta = with lib; {
    homepage = "http://faculty.cse.tamu.edu/davis/suitesparse.html";
    description = "A suite of sparse matrix algorithms";
    license = with licenses; [ bsd2 gpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ ttuegel ];
    platforms = with platforms; unix;
  };
}
