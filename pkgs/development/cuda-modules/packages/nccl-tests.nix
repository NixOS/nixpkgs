# NOTE: Though NCCL tests is called within the cudaPackages package set, we avoid passing in
# the names of dependencies from that package set directly to avoid evaluation errors
# in the case redistributable packages are not available.
{
  config,
  cudaAtLeast,
  cudaOlder,
  cudaMajorMinorVersion,
  cudaPackages,
  fetchFromGitHub,
  gitUpdater,
  lib,
  mpi,
  mpiSupport ? false,
  nccl,
  which,
}:
let
  inherit (cudaPackages)
    backendStdenv
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    cudatoolkit
    ;
in
backendStdenv.mkDerivation (finalAttrs: {
  name = "cuda${cudaMajorMinorVersion}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "nccl-tests";
  version = "2.13.9";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-QYuMBPhvHHVo2ku14jD1CVINLPW0cyiXJkXxb77IxbE=";
  };

  strictDeps = true;

  nativeBuildInputs =
    [ which ]
    ++ lib.optionals (cudaOlder "11.4") [ cudatoolkit ]
    ++ lib.optionals (cudaAtLeast "11.4") [ cuda_nvcc ];

  buildInputs =
    [ nccl ]
    ++ lib.optionals (cudaOlder "11.4") [ cudatoolkit ]
    ++ lib.optionals (cudaAtLeast "11.4") [
      cuda_nvcc.dev # crt/host_config.h
      cuda_cudart
    ]
    ++ lib.optionals (cudaAtLeast "12.0") [
      cuda_cccl.dev # <nv/target>
    ]
    ++ lib.optionals mpiSupport [ mpi ];

  makeFlags =
    [ "NCCL_HOME=${nccl}" ]
    ++ lib.optionals (cudaOlder "11.4") [ "CUDA_HOME=${cudatoolkit}" ]
    # NOTE: CUDA_HOME is expected to have the bin directory
    ++ lib.optionals (cudaAtLeast "11.4") [ "CUDA_HOME=${cuda_nvcc.bin}" ]
    ++ lib.optionals mpiSupport [ "MPI=1" ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p "$out/bin"
    cp -r build/* "$out/bin/"
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
