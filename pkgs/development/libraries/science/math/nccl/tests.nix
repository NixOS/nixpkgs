{ backendStdenv
, config
, cuda_cccl
, cuda_cudart
, cuda_nvcc
, cudaVersion
, fetchFromGitHub
, gitUpdater
, lib
, mpi
, mpiSupport ? false
, nccl
, which
}:

backendStdenv.mkDerivation (finalAttrs: {

  pname = "nccl-tests";
  version = "2.13.8";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-dxLoflsTHDBnZRTzoXdm30OyKpLlRa73b784YWALBHg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cuda_nvcc
    which
  ];

  buildInputs = [
    cuda_cudart
    nccl
  ] ++ lib.optionals (lib.versionAtLeast cudaVersion "12.0") [
    cuda_cccl.dev # <nv/target>
  ] ++ lib.optional mpiSupport mpi;

  makeFlags = [
    "CUDA_HOME=${cuda_nvcc}"
    "NCCL_HOME=${nccl}"
  ] ++ lib.optionals mpiSupport [
    "MPI=1"
  ];

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
