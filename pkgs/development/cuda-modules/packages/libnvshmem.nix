{
  _cuda,
  autoAddDriverRunpath,
  backendStdenv,
  buildPackages,
  cmake,
  cccl,
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
  patchelf,
  pmix,
  python3Packages,
  rdma-core,
  removeReferencesTo,
  ucx,
  # passthru.updateScript
  gitUpdater,

  withGdrcopy ? true,
  withIbgda ? true,
  withLibfabric ? true,
  withMpi ? true,
  withNccl ? nccl.meta.available,
  withPmix ? true,
  withUcx ? true,
}:
let
  inherit (lib)
    cmakeBool
    cmakeFeature
    concatMapStringsSep
    getBin
    getDev
    getExe
    getLib
    licenses
    maintainers
    makeLibraryPath
    optional
    optionalString
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
    # libnvshmem_host dlopens libcuda.so.1 and libnvidia-ml.so.1 by bare soname
    # (src/host/init/{cudawrap,nvmlwrap}.cpp).
    autoAddDriverRunpath
    cuda_nvcc
    cmake
    ninja
    patchelf

    # NOTE: Python is required even if not building nvshmem4py:
    # https://github.com/NVIDIA/nvshmem/blob/131da55f643ac87c810ba0bc51d359258bf433a1/CMakeLists.txt#L173
    python3Packages.python
    removeReferencesTo
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
    cccl
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

  # These are all dlopen'd by bare soname, so buildInputs alone never reaches a RUNPATH. The contrast
  # is visible within this package: ibgda links libmlx5.so.1 and so does pick up rdma-core, while
  # ibrc -- the default transport -- only dlopens libibverbs.so.1 and would get nothing.
  postFixup =
    # Skips entries already present, so ibgda does not end up with rdma-core twice.
    ''
      addMissing() {
        local elf=$1 rp d
        shift
        rp=$(patchelf --print-rpath "$elf")
        for d in "$@"; do [[ ":$rp:" == *":$d:"* ]] || rp=''${rp:+$rp:}$d; done
        patchelf --set-rpath "$rp" "$elf"
      }
    ''
    + ''
      nixLog "adding dlopen'd transport libraries to the transport plugins' runpath"
      for transport in "$out"/lib/nvshmem_transport_*.so.*.*; do
        addMissing "$transport" ${makeLibraryPath ([ rdma-core ] ++ optional withGdrcopy gdrcopy)}
      done
    ''
    # libnvshmem_host dlopens libnccl.so.2 for host-side collectives (src/host/coll/cpu_coll.cpp).
    + optionalString withNccl ''
      nixLog "adding nccl to libnvshmem_host's runpath"
      addMissing "$out"/lib/libnvshmem_host.so.*.* "${getLib nccl}/lib"
    ''
    # cmake_config/NVSHMEMEnv.cmake:156 bakes every -D*_HOME we pass into NVSHMEM_BUILD_VARS, a
    # diagnostic banner that nvshmem-info and init.cu only print. Nix still counts the store paths, so
    # build-only inputs become runtime dependencies -- and the banner is substituted into an installed
    # header, so consumers inherit them too. Only the dev outputs and nvcc are stripped: gdrcopy and
    # mpi appear in the same string but are genuine runtime dependencies. No disallowedRequisites
    # guard here, unlike nccl and gdrcopy, because ucx and openmpi pull nvcc in on their own.
    + ''
      nixLog "removing build-time references baked into NVSHMEM_BUILD_VARS"
      remove-references-to ${
        concatMapStringsSep " " (p: ''-t "${p}"'') (
          [ (getBin cuda_nvcc) ]
          ++ optional withNccl (getDev nccl)
          ++ optional withUcx (getDev ucx)
          ++ optional withLibfabric (getDev libfabric)
          ++ optional withPmix (getDev pmix)
        )
      } \
        "$out"/bin/nvshmem-info \
        "$out"/lib/libnvshmem_host.so.*.* \
        "$out"/include/non_abi/nvshmem_version.h \
        "$out"/share/src/*/include/non_abi/nvshmem_version.h
    '';

  doCheck = false;

  passthru = {
    updateScript = gitUpdater {
      inherit (finalAttrs) pname version;
      rev-prefix = "v";
    };

    brokenAssertions = [
      # CUDA pre-11.7 yields macro/type errors in src/include/internal/host_transport/cudawrap.h.
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
