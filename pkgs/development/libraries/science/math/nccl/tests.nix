{ config
, cudaPackages
, fetchFromGitHub
, lib
, mpiSupport ? false
, mpi
, stdenv
, which
}:

cudaPackages.backendStdenv.mkDerivation (finalAttrs: {

  pname = "nccl-tests";
  version = "2.13.6";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-3gSBQ0g6mnQ/MFXGflE+BqqrIUoiBgp8+fWRQOvLVkw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cudaPackages.cuda_nvcc
    which
  ];

  buildInputs = [
    cudaPackages.cuda_cudart
    cudaPackages.nccl
  ] ++ lib.optional mpiSupport mpi;

  makeFlags = [
    "CUDA_HOME=${cudaPackages.cuda_nvcc}"
    "NCCL_HOME=${cudaPackages.nccl}"
  ] ++ lib.optionals mpiSupport [
    "MPI=1"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -r build/* $out/bin/
  '';

  meta = with lib; {
    description = "Tests to check both the performance and the correctness of NVIDIA NCCL operations";
    homepage = "https://github.com/NVIDIA/nccl-tests";
    platforms = [ "x86_64-linux" ];
    license = licenses.bsd3;
    broken = !config.cudaSupport || (mpiSupport && mpi == null);
    maintainers = with maintainers; [ jmillerpdt ];
  };
})
