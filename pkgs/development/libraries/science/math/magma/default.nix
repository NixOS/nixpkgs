{ lib, stdenv, fetchurl, cmake, gfortran, ninja, cudaPackages, libpthreadstubs, lapack, blas }:

let
  inherit (cudaPackages) cudatoolkit;
in

assert let majorIs = lib.versions.major cudatoolkit.version;
       in majorIs == "9" || majorIs == "10" || majorIs == "11";

let
  version = "2.6.2";

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
    hash = "sha256-dbVU2rAJA+LRC5cskT5Q5/iMvGLzrkMrWghsfk7aCnE=";
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

  meta = with lib; {
    description = "Matrix Algebra on GPU and Multicore Architectures";
    license = licenses.bsd3;
    homepage = "http://icl.cs.utk.edu/magma/index.html";
    platforms = platforms.unix;
    maintainers = with maintainers; [ tbenst ];
  };

  passthru.cudatoolkit = cudatoolkit;
}
