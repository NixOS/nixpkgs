{ lib
, stdenv
, fetchFromGitHub
, which
, cudaPackages
, mpiSupport ? false
, mpi
}:

assert mpiSupport -> mpi != null;

with cudaPackages;

cudaPackages.backendStdenv.mkDerivation rec {

  pname = "nccl-tests";
  version = "2.13.6";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3gSBQ0g6mnQ/MFXGflE+BqqrIUoiBgp8+fWRQOvLVkw=";
  };

  nativeBuildInputs = [ which cuda_nvcc ];

  buildInputs = [
    cuda_cudart
    nccl
  ] ++ lib.optional mpiSupport mpi;

  makeFlags = [
    "CUDA_HOME=${cudatoolkit}"
    "NCCL_HOME=${nccl}"
  ] ++ lib.optionals mpiSupport [
    "MPI=1"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -r build/* $out/bin/
  '';

  meta = with lib; {
    description = "Tests to check both the performance and the correctness of NVIDIA NCCL operations.";
    homepage = "https://github.com/NVIDIA/nccl-tests";
    platforms = [ "x86_64-linux" ];
    license = licenses.bsd3;
    maintainers = with maintainers; [ jmillerpdt ];
  };
}
