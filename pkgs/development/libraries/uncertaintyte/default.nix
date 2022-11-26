{ stdenv
, fetchFromGitHub
, cmake
, gflags
, eigen
, blas
, lapack
, ceres-solver
, cudatoolkit
, magma
}:

stdenv.mkDerivation rec {
  pname = "uncertaintyte";
  version = "2018-03-06";
  src = fetchFromGitHub {
    owner = "alicevision";
    repo = "uncertaintyte";
    rev = "d995765f7bb105214ceef974e0a795213479f74c";
    sha256 = "otYwhBWN5KuXUAbLPYd1P5SIy3Bwu2QglA3HWl+HjPM=";
  };
  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    gflags
    eigen
    blas
    lapack
    ceres-solver
    cudatoolkit
    magma
  ];
}
