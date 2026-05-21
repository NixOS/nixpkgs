{
  _cuda,
  backendStdenv,
  buildPackages,
  cmake,
  cuda_cccl,
  cuda_cudart,
  cuda_nvcc,
  cuda_nvml_dev,
  cuda_nvrtc,
  cuda_nvtx,
  cudaAtLeast,
  cudaMajorMinorVersion,
  cudaNamePrefix,
  fetchFromGitHub,
  flags,
  gdrcopy,
  lib,
  libfabric,
  libnvjitlink,
  mpi,
  nccl,
  ninja,
  pmix,
  python3Packages,
  rdma-core,
  ucx,
  # passthru.updateScript
  gitUpdater,

  withGdrcopy ? true,
  withIbgda ? true,
  withLibfabric ? true,
  withMpi ? true,
  withNccl ? true,
  withPmix ? true,
  withUcx ? true,
}:
let
  inherit (lib)
    cmakeBool
    cmakeFeature
    getBin
    getDev
    getExe
    getLib
    licenses
    maintainers
    optional
    optionals
    teams
    ;
in
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  # NOTE: Depends on the CUDA package set, so use cudaNamePrefix.
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "libnvshmem";
  version = "3.6.5-0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvshmem";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2E3/WGbg6srT/e3ykK0qxTy1ZlJ9JGGLlergG0ITwTY=";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [
    cuda_nvcc
    cmake
    ninja

    # NOTE: Python is required even if not building nvshmem4py:
    # https://github.com/NVIDIA/nvshmem/blob/131da55f643ac87c810ba0bc51d359258bf433a1/CMakeLists.txt#L173
    python3Packages.python
  ]
  ++ optionals withMpi [
    # NOTE: mpi is in nativeBuildInputs because it contains compilers and is only discoverable by CMake
    # when a nativeBuildInput.
    mpi
  ];

  # NOTE: Hardcoded standard versions mean CMake doesn't respect values we provide, so we need to patch the files.
  postPatch = ''
    for standardName in {CXX,CUDA}_STANDARD
    do
      while IFS= read -r cmakeFileToPatch
      do
        nixLog "patching $PWD/$cmakeFileToPatch to fix $standardName"
        substituteInPlace "$PWD/$cmakeFileToPatch" \
          --replace-fail \
            "$standardName 11" \
            "$standardName 17"
      done < <(grep --recursive --files-with-matches "$standardName 11")
    done
    unset -v cmakeFileToPatch
    unset -v standardName
  '';

  enableParallelBuilding = true;

  buildInputs = [
    cuda_cccl
    cuda_cudart
    cuda_nvml_dev
    cuda_nvrtc
    cuda_nvtx
    libnvjitlink
    rdma-core
  ]
  ++ optionals withLibfabric [
    libfabric
  ]
  ++ optionals withGdrcopy [
    gdrcopy
  ]
  ++ optionals withNccl [
    nccl
  ]
  ++ optionals withPmix [
    pmix
  ]
  ++ optionals withUcx [
    ucx
  ];

  # NOTE: This *must* be an environment variable NVIDIA saw fit to *configure and build CMake projects* while *inside*
  # a CMake build and didn't correctly thread arguments through, so the environment is the only way to get
  # configurations to the nested build.
  env.CUDA_HOME = (getBin cuda_nvcc).outPath;

  # https://docs.nvidia.com/nvshmem/release-notes-install-guide/install-guide/nvshmem-install-proc.html#other-distributions
  cmakeFlags = lib.concatLists [
    [
      (cmakeFeature "NVSHMEM_PREFIX" (placeholder "out"))

      (cmakeFeature "CUDA_HOME" (getBin cuda_nvcc).outPath)
      (cmakeFeature "CMAKE_CUDA_COMPILER" (getExe cuda_nvcc))

      (cmakeFeature "CMAKE_CUDA_ARCHITECTURES" flags.cmakeCudaArchitecturesString)

      (cmakeBool "NVSHMEM_BUILD_TESTS" true)
      (cmakeBool "NVSHMEM_BUILD_EXAMPLES" true)

      (cmakeBool "NVSHMEM_BUILD_DEB_PACKAGE" false)
      (cmakeBool "NVSHMEM_BUILD_RPM_PACKAGE" false)

      # TODO: Looks like a nightmare to package and depends on things we haven't packaged yet
      # https://github.com/NVIDIA/nvshmem/tree/131da55f643ac87c810ba0bc51d359258bf433a1/nvshmem4py
      (cmakeBool "NVSHMEM_BUILD_PYTHON_LIB" false)

      # NOTE: unsupported because it requires Clang
      (cmakeBool "NVSHMEM_BUILD_BITCODE_LIBRARY" false)
    ]

    [ (cmakeBool "NVSHMEM_USE_NCCL" withNccl) ]
    (optional withNccl (cmakeFeature "NCCL_HOME" (getDev nccl).outPath))

    [ (cmakeBool "NVSHMEM_USE_GDRCOPY" withGdrcopy) ]
    (optional withGdrcopy (cmakeFeature "GDRCOPY_HOME" (getDev gdrcopy).outPath))

    # NOTE: Make sure to use mpi from buildPackages to match the spliced version created through nativeBuildInputs.
    [ (cmakeBool "NVSHMEM_MPI_SUPPORT" withMpi) ]
    (optional withMpi (cmakeFeature "MPI_HOME" (getLib buildPackages.mpi).outPath))

    # TODO: Doesn't UCX need to be built with some argument when we want to use it with libnvshmem?
    [ (cmakeBool "NVSHMEM_UCX_SUPPORT" withUcx) ]
    (optional withUcx (cmakeFeature "UCX_HOME" (getDev ucx).outPath))

    [ (cmakeBool "NVSHMEM_LIBFABRIC_SUPPORT" withLibfabric) ]
    (optional withLibfabric (cmakeFeature "LIBFABRIC_HOME" (getDev libfabric).outPath))

    # NOTE: no corresponding _HOME variable for IBGDA.
    [ (cmakeBool "NVSHMEM_IBGDA_SUPPORT" withIbgda) ]

    [ (cmakeBool "NVSHMEM_PMIX_SUPPORT" withPmix) ]
    (optional withPmix (cmakeFeature "PMIX_HOME" (getDev pmix).outPath))
  ];

  postInstall = ''
    nixLog "moving top-level files in $out to $out/share"
    mv -v "$out"/{changelog,git_commit.txt,License.txt,version.txt} "$out/share/"
  '';

  doCheck = false;

  passthru = {
    updateScript = gitUpdater {
      inherit (finalAttrs) pname version;
      rev-prefix = "v";
    };

    brokenAssertions = [
      # CUDA pre-11.7 yeilds macro/type errors in src/include/internal/host_transport/cudawrap.h.
      {
        message = "NVSHMEM does not support CUDA releases earlier than 11.7 (found ${cudaMajorMinorVersion})";
        assertion = cudaAtLeast "11.7";
      }
    ];
  };

  meta = {
    description = "Parallel programming interface for NVIDIA GPUs based on OpenSHMEM";
    homepage = "https://github.com/NVIDIA/nvshmem";
    changelog = "https://github.com/NVIDIA/nvshmem/releases/tag/${finalAttrs.src.tag}";
    broken = _cuda.lib._mkMetaBroken finalAttrs;
    # NOTE: There are many licenses:
    # https://github.com/NVIDIA/nvshmem/blob/7dd48c9fd7aa2134264400802881269b7822bd2f/License.txt
    license = licenses.nvidiaCudaRedist;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [
      connorbaker
      GaetanLepage
    ];
    teams = [ teams.cuda ];
  };
})
