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
    cudaAtLeast
    nccl
    ;
in
backendStdenv.mkDerivation (finalAttrs: {

  pname = "nccl-tests";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nccl-tests";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OgffbW9Vx/sm1I1tpaPGdAhIpV4jbB4hJa9UcEAWkdE=";
  };

  postPatch = ''
    # fix build failure with GCC14
    substituteInPlace src/Makefile --replace-fail "-std=c++11" "-std=c++14"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    which
    cuda_nvcc
  ];

  buildInputs = [
    nccl
    cuda_nvcc # crt/host_config.h
    cuda_cudart
    cuda_cccl # <nv/target>
  ]
  ++ lib.optionals mpiSupport [ mpi ];

  makeFlags = [
    "NCCL_HOME=${nccl}"
    "CUDA_HOME=${cuda_nvcc}"
  ]
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
    maintainers = with maintainers; [ jmillerpdt ];
    teams = [ teams.cuda ];
  };
})
