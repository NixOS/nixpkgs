{ lib, stdenv, fetchurl, cmake, gfortran, ninja, cudatoolkit, libpthreadstubs, lapack, blas }:

assert let majorIs = lib.versions.major cudatoolkit.version;
       in majorIs == "9" || majorIs == "10" || majorIs == "11";

let
  version = "2.5.4";

  # We define a specific set of CUDA compute capabilities here,
  # because CUDA 11 does not support compute capability 3.0. Also,
  # we use it to enable newer capabilities that are not enabled
  # by magma by default. The list of supported architectures
  # can be found in magma's top-level CMakeLists.txt.
  cudaCapabilities = rec {
    cuda9 = [
      "Kepler"  # 3.0, 3.5
      "Maxwell" # 5.0
      "Pascal"  # 6.0
      "Volta"   # 7.0
    ];

    cuda10 = [
      "Turing"  # 7.5
    ] ++ cuda9;

    cuda11 = [
      "sm_35"   # sm_30 is not supported by CUDA 11
      "Maxwell" # 5.0
      "Pascal"  # 6.0
      "Volta"   # 7.0
      "Turing"  # 7.5
      "Ampere"  # 8.0
    ];
  };

  capabilityString = lib.strings.concatStringsSep ","
    cudaCapabilities."cuda${lib.versions.major cudatoolkit.version}";

in stdenv.mkDerivation {
  pname = "magma";
  inherit version;
  src = fetchurl {
    url = "https://icl.cs.utk.edu/projectsfiles/magma/downloads/magma-${version}.tar.gz";
    sha256 = "0rrvd21hczxlm8awc9z54fj7iqpjmsb518fy32s6ghz0g90znd3p";
    name = "magma-${version}.tar.gz";
  };

  nativeBuildInputs = [ gfortran cmake ninja ];

  buildInputs = [ cudatoolkit libpthreadstubs lapack blas ];

  cmakeFlags = [ "-DGPU_TARGET=${capabilityString}" ];

  doCheck = false;

  preConfigure = ''
    export CC=${cudatoolkit.cc}/bin/gcc CXX=${cudatoolkit.cc}/bin/g++
  '';

  enableParallelBuilding=true;
  buildFlags = [ "magma" "magma_sparse" ];

  # MAGMA's default CMake setup does not care about installation. So we copy files directly.
  installPhase = ''
    mkdir -p $out
    mkdir -p $out/include
    mkdir -p $out/lib
    mkdir -p $out/lib/pkgconfig
    cp -a ../include/*.h $out/include
    #cp -a sparse-iter/include/*.h $out/include
    cp -a lib/*.so $out/lib
    cat ../lib/pkgconfig/magma.pc.in                   | \
    sed -e s:@INSTALL_PREFIX@:"$out":          | \
    sed -e s:@CFLAGS@:"-I$out/include":    | \
    sed -e s:@LIBS@:"-L$out/lib -lmagma -lmagma_sparse": | \
    sed -e s:@MAGMA_REQUIRED@::                       \
        > $out/lib/pkgconfig/magma.pc
  '';

  meta = with lib; {
    description = "Matrix Algebra on GPU and Multicore Architectures";
    license = licenses.bsd3;
    homepage = "http://icl.cs.utk.edu/magma/index.html";
    platforms = platforms.unix;
    maintainers = with maintainers; [ tbenst ];
  };

  passthru.cudatoolkit = cudatoolkit;
}
