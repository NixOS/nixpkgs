# NOTE: Though NCCL tests is called within the cudaPackages package set, we avoid passing in
# the names of dependencies from that package set directly to avoid evaluation errors
# in the case redistributable packages are not available.
{
  config,
  cudaPackages,
  fetchFromGitHub,
  gitUpdater,
  lib,
  mpi,
  mpiSupport ? false,
  which,
}:
let
  inherit (cudaPackages)
    backendStdenv
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    cudatoolkit
    cudaVersion
    nccl
    ;
in
backendStdenv.mkDerivation (finalAttrs: {

  pname = "nccl-tests";
  version = "2.13.11";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nccl-tests";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HHshp4fYW+dlyL9FZRxX761UCFR/pOBKNHfVme2TfJg=";
  };

  strictDeps = true;

  nativeBuildInputs =
    [ which ]
    ++ lib.optionals (lib.versionOlder cudaVersion "11.4") [ cudatoolkit ]
    ++ lib.optionals (lib.versionAtLeast cudaVersion "11.4") [ cuda_nvcc ];

  buildInputs =
    [ nccl ]
    ++ lib.optionals (lib.versionOlder cudaVersion "11.4") [ cudatoolkit ]
    ++ lib.optionals (lib.versionAtLeast cudaVersion "11.4") [
      cuda_nvcc # crt/host_config.h
      cuda_cudart
    ]
    ++ lib.optionals (lib.versionAtLeast cudaVersion "12.0") [
      cuda_cccl # <nv/target>
    ]
    ++ lib.optionals mpiSupport [ mpi ];

  makeFlags =
    [ "NCCL_HOME=${nccl}" ]
    ++ lib.optionals (lib.versionOlder cudaVersion "11.4") [ "CUDA_HOME=${cudatoolkit}" ]
    ++ lib.optionals (lib.versionAtLeast cudaVersion "11.4") [ "CUDA_HOME=${cuda_nvcc}" ]
    ++ lib.optionals mpiSupport [ "MPI=1" ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -r build/* $out/bin/
  '';

  passthru.updateScript = gitUpdater {
    inherit (finalAttrs) pname version;
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Tests to check both the performance and the correctness of NVIDIA NCCL operations";
    homepage = "https://github.com/NVIDIA/nccl-tests";
    platforms = platforms.linux;
    license = licenses.bsd3;
    broken = !config.cudaSupport || (mpiSupport && mpi == null);
    maintainers = with maintainers; [ jmillerpdt ] ++ teams.cuda.members;
  };
})
