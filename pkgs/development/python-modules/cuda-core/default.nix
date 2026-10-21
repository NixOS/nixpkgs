{
  lib,
  config,
  buildPythonPackage,
  cudaPackages,
  fetchFromGitHub,
  fetchpatch,
  replaceVars,
  pythonOlder,

  # build-system
  cuda-bindings,
  cuda-pathfinder,
  cython,
  setuptools,
  setuptools-scm,

  # dependencies
  numpy,

  # tests
  cffi,
  cloudpickle,
  docutils,
  packaging,
  psutil,
  pyglet,
  pytestCheckHook,

  # passthru
  cuda-core,
  python,
  runCommand,

  cudaSupport ? config.cudaSupport,
}:
buildPythonPackage.override { stdenv = cudaPackages.backendStdenv; } (finalAttrs: {
  pname = "cuda-core";
  version = "1.2.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cuda-python";
    tag = "cuda-core-v${finalAttrs.version}";
    # GitHub expands the export-subst'd .git_archival.txt when generating the tarball. Its ref-names line lists every
    # branch pointing at the tagged commit, so the hash changes when e.g. a release branch moves on, even though the tag
    # did not. Keep only the tag, which setuptools-scm still resolves to the right version.
    postFetch = ''
      sed -i 's/^ref-names: .*$/ref-names: tag: cuda-core-v${finalAttrs.version}/' "$out/.git_archival.txt"
      grep -qx 'ref-names: tag: cuda-core-v${finalAttrs.version}' "$out/.git_archival.txt"
    '';
    hash = "sha256-UH5fw08Y6a8uUtAuxxoahyVH6W58xdlWfrSsB4mMvPc=";
  };

  sourceRoot = "${finalAttrs.src.name}/cuda_core";

  # The build reads the CUDA major version from $CUDA_HOME/include/cuda.h and adds $CUDA_HOME/include to the include
  # path; every other header comes from buildInputs.
  env.CUDA_HOME = lib.getInclude cudaPackages.cuda_cudart;

  patches = [
    # Compile out the CCCL-based TMA descriptor path. It's used whenever <cuda/tma> is found at build time, which upstream's
    # own builds never do, and doesn't work: it references cudart symbols the extension doesn't link, so with CCCL on the
    # include path importing cuda.core fails with "undefined symbol: cudaGetErrorString".
    # https://github.com/NVIDIA/cuda-python/pull/2777
    (fetchpatch {
      name = "cuda-core-disable-cccl-tma.patch";
      url = "https://github.com/NVIDIA/cuda-python/commit/c2fc72bf083564511f33ae94448665693d189b14.patch";
      relative = "cuda_core";
      hash = "sha256-bfy+CFp8PCu383qobuEb9undcMFmnW+WlkYHhloip3k=";
    })
  ]
  # Tests and examples compile code with NVRTC against $CUDA_HOME/include and its cccl/ subdirectory, which assumes one
  # CUDA Toolkit root. Point them at the separate CCCL and runtime header prefixes instead. Only when testing, so that
  # the package itself doesn't depend on CCCL.
  ++ lib.optionals finalAttrs.doInstallCheck [
    (replaceVars ./cuda-include-paths.patch {
      cccl = "${lib.getInclude cudaPackages.cccl}/include";
      cudartInclude = "${lib.getInclude cudaPackages.cuda_cudart}/include";
    })
  ];

  postPatch =
    # Relax cython constraint: https://github.com/NVIDIA/cuda-python/pull/2771
    ''
      substituteInPlace pyproject.toml \
        --replace-fail \
          '"Cython>=3.2.5,<3.3",' \
          '"Cython>=3.2.5",'
    ''
    # Cython 3.3 warns that some attribute accesses are not usefully protected by critical_section
    # (only relevant for free-threaded builds), which fails the build with python 3.13.
    # Fixed by the same upstream PR.
    + lib.optionalString (pythonOlder "3.14") ''
      substituteInPlace build_hooks.py \
        --replace-fail \
          "_CythonOptions.warning_errors = True" \
          "_CythonOptions.warning_errors = False"
    '';

  build-system = [
    cuda-bindings
    cuda-pathfinder
    cython
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    cudaPackages.cuda_nvrtc # nvrtc.h
    cudaPackages.cuda_profiler_api # cudaProfiler.h
  ]
  # The RDC test fixtures compile tests/test_binaries/saxpy.cu with nvcc
  ++ lib.optionals finalAttrs.doInstallCheck [
    cudaPackages.cuda_cudart # cuda_runtime.h
  ];

  preBuild = ''
    export CUDA_PYTHON_PARALLEL_LEVEL=$NIX_BUILD_CORES
  '';

  dependencies = [
    cuda-bindings
    cuda-pathfinder
    numpy
  ];

  pythonImportsCheck = [ "cuda.core" ];

  preCheck =
    # Force tests to import `cuda.core` from `$out` instead of from `$PWD`
    ''
      rm -rf cuda/core
    ''
    # The checkpoint scenarios run in a child interpreter started with -I, which ignores PYTHONPATH and so can't import
    # pytest
    + ''
      substituteInPlace tests/test_checkpoint.py \
        --replace-fail \
          '[sys.executable, "-I", ' \
          '[sys.executable, '
    '';

  nativeCheckInputs = [
    cffi
    cloudpickle
    docutils
    packaging
    psutil
    pyglet
    pytestCheckHook
    setuptools
  ];

  disabledTests = [
    # Fail inside the sandbox:
    #   cuda.bindings.nvml.UnknownError: Unknown Error
    #   hwloc/linux: failed to find sysfs cpu topology directory, aborting linux discovery.
    "test_affinity"
    "test_device_cpu_affinity"
    "test_device_pci_bus_id"
    "test_device_pci_info"
    "test_system_event_device_resolves_pci_bus_id"
    "test_to_cuda_device"
    "test_to_system_device"

    # cuda.core._utils.cuda_utils.CUDAError: CUDA_ERROR_INVALID_VALUE
    "test_host_numa_current_location_hint"

    # cuda-bindings 13.4 has enum members this release of cuda.core doesn't map yet (BRAND_NVIDIA_NPU,
    # NvlinkVersion.VERSION_6_0, EVENT_REASON_BOARD_LIMIT, ...), and recent drivers report them:
    #   ValueError: Unknown clock event reason bit: 1024
    "test_wrapper_covers_all_binding_members"
    "test_clock_event_reasons"

    # Assumes green context SM partitions of at least 8 on compute capability >= 9.0; GB10 (12.1) reports 2
    "test_arch_constraints_hopper_plus"
  ];

  disabledTestPaths = [
    # AssertionError (tries to run an external python process that imports `cuda`)
    # ModuleNotFoundError: No module named 'cuda'
    "tests/test_rlcompleter_patch.py"
  ];

  # Tests require a GPU
  doCheck = false;

  passthru = {
    # bulk updater uses wrong tag
    skipBulkUpdate = true;
    tests = {
      import-clean-env =
        runCommand "import-clean-env-cuda-core"
          {
            nativeBuildInputs = [ (python.withPackages (_: [ finalAttrs.finalPackage ])) ];
          }
          ''
            python -c 'import cuda.core'
            touch $out
          '';
    };
    gpuCheck = cuda-core.overridePythonAttrs {
      requiredSystemFeatures = [ "cuda" ];
      doCheck = true;
    };
  };

  meta = {
    description = "Pythonic interface to the CUDA runtime";
    homepage = "https://nvidia.github.io/cuda-python/cuda-core/latest";
    downloadPage = "https://github.com/NVIDIA/cuda-python/tree/main/cuda_core";
    changelog = "https://nvidia.github.io/cuda-python/cuda-core/latest/release/${finalAttrs.version}-notes.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
    ];
    broken = !cudaSupport;
  };
})
