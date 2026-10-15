{
  lib,
  config,
  addDriverRunpath,
  buildPythonPackage,
  cudaPackages,
  fetchFromGitHub,
  python,
  replaceVars,

  # build-system
  numpy,
  setuptools,

  # dependencies
  cuda-bindings,
  cuda-core,
  cuda-pathfinder,
  numba,
  packaging,

  # tests
  cffi,
  filecheck,
  ml-dtypes,
  pytest-benchmark,
  pytest-subtests,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  # `libnvvm` is bundled in `cuda_nvcc` up to CUDA 12.x, and standalone from 13.0 onwards
  nvvmRoot =
    if cudaPackages.cudaOlder "13.0" then
      "${lib.getLib cudaPackages.cuda_nvcc}/nvvm"
    else
      lib.getLib cudaPackages.libnvvm;

  libCudaPath =
    # `cuda_compat` provides `libcuda.so` on pre-Thor Jetsons
    if (cudaPackages.cuda_compat.meta.available or false) then
      cudaPackages.cuda_compat
    # Else: the host driver library
    else
      addDriverRunpath.driverLink;

  cudartInclude = "${lib.getInclude cudaPackages.cuda_cudart}/include";
  # `cuda/atomic` & al., to compile the NRT headers with NVRTC
  ccclInclude = "${lib.getInclude cudaPackages.cccl}/include";
in

buildPythonPackage.override { stdenv = cudaPackages.backendStdenv; } (finalAttrs: {
  pname = "numba-cuda";
  version = "0.30.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "numba-cuda";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wk5pf5gh7lUgai50KEazpfdyYu0k7dcDN7lhCJfjWEM=";
  };

  patches = [
    # Resolve the CUDA components from the store instead of walking a toolkit root, which nixpkgs
    # does not have. Mirrors `cuda-bindings`' `patch-nvidia-libs-paths_*.patch`.
    (replaceVars ./nvidia-libs-paths.patch {
      inherit cudartInclude;
      cccl = ccclInclude;
      libcudart = lib.getLib cudaPackages.cuda_cudart;
      libcudartStatic = lib.getOutput "static" cudaPackages.cuda_cudart;
      libnvrtc = lib.getLib cudaPackages.cuda_nvrtc;
      libnvvm = nvvmRoot;
    })
  ];

  postPatch =
    # numpy 2.5 removed `np.row_stack`; numba guards its own copy the same way
    ''
      substituteInPlace numba_cuda/numba/cuda/np/arrayobj.py \
        --replace-fail \
          "if numpy_version >= (2, 0):" \
          "if (2, 0) <= numpy_version < (2, 5):"
    ''
    # `libcuda.so` is looked up in hardcoded FHS dirs, and the `NUMBA_CUDA_DRIVER` override is gone
    + ''
      substituteInPlace numba_cuda/numba/cuda/cudadrv/driver.py \
        --replace-fail \
          'dldir = ["/usr/lib", "/usr/lib64"]' \
          'dldir = ["${libCudaPath}/lib"]'
    ''
    # Expanded at parse time even when overridden, making the build log look like `make` failed
    + ''
      substituteInPlace testing/Makefile \
        --replace-fail "GPU_CC := " "GPU_CC ?= "
    ''
    # `determine_include_flags()` wants a single `INCLUDES=` line from `nvcc -v`; nixpkgs' prints
    # two, neither carrying the runtime headers
    + ''
      substituteInPlace testing/generate_raw_ltoir.py \
        --replace-fail \
          "cuda_include_flags = determine_include_flags() + (" \
          "cuda_include_flags = [\"-I${cudartInclude}\", \"-I${ccclInclude}\"] + ("
    '';

  build-system = [
    numpy
    setuptools
  ];

  dependencies = [
    cuda-bindings
    cuda-core
    cuda-pathfinder
    numba
    packaging
  ];

  env = {
    # No GPU in the sandbox, so only the simulator runs here; devices: `passthru.gpuCheck`
    NUMBA_ENABLE_CUDASIM = "1";
  };

  pythonImportsCheck = [ "numba_cuda" ];

  nativeCheckInputs = [
    cffi
    filecheck
    ml-dtypes
    pytest-benchmark
    pytest-subtests
    pytestCheckHook
    # `test_non_*_pycache` fall back to the user-wide numba cache
    writableTmpDirAsHomeHook
  ];

  preCheck =
    # `numba_cuda/numba/` in the source root shadows the installed package, which `testing/`
    # collects instead through `--pyargs`
    ''
      cd testing
      export NUMBA_CUDA_TEST_BIN_DIR="$PWD"
    ''
    # The `.pth` redirecting `numba.cuda` is only honoured for `NIX_PYTHONPATH`, not `PYTHONPATH`
    + ''
      export NIX_PYTHONPATH="$out/${python.sitePackages}''${NIX_PYTHONPATH:+:$NIX_PYTHONPATH}"
    ''
    # pytest 9 hides rootdir `conftest.py` fixtures from tests collected elsewhere: load it as a
    # plugin instead
    + ''
      mv conftest.py numba_cuda_pytest_plugin.py
    ''
    # `sitecustomize.py` pops `NIX_PYTHONPATH`, so interpreters spawned by tests skip the `.pth`
    # above and import numba's own `numba.cuda`. Put it back.
    + ''
      echo "import os; os.environ['NIX_PYTHONPATH'] = '$NIX_PYTHONPATH'" \
        > nix_pythonpath_plugin.py
    '';

  pytestFlags = [
    "-pnix_pythonpath_plugin"
    "-pnumba_cuda_pytest_plugin"
    # Upstream turns warnings into errors, tripping over numba's own import-time deprecations
    "-ofilterwarnings="
  ];

  passthru.gpuCheck = finalAttrs.finalPackage.overrideAttrs (old: {
    requiredSystemFeatures = [ "cuda" ];

    nativeBuildInputs = old.nativeBuildInputs ++ [
      # `inspect_obj_content` shells out to `cuobjdump` on `PATH`
      cudaPackages.cuda_cuobjdump
      cudaPackages.cuda_nvcc
    ];

    # cuda_runtime.h, cuda_fp16.h
    buildInputs = old.buildInputs ++ [ cudaPackages.cuda_cudart ];

    env = old.env // {
      NUMBA_ENABLE_CUDASIM = "0";
    };

    preCheck =
      old.preCheck
      # Build the fixtures the `cudadrv` and `nrt` tests link against. They hold SASS for a single
      # capability, so it must be the test GPU's, and `nvidia-smi` is not in the sandbox.
      + ''
        make GPU_CC=$(python -c \
          'from numba import cuda; print("%d%d" % cuda.get_current_device().compute_capability)')
      '';
  });

  meta = {
    description = "The CUDA target for Numba";
    homepage = "https://github.com/NVIDIA/numba-cuda";
    changelog = "https://github.com/NVIDIA/numba-cuda/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    teams = [ lib.teams.cuda ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    broken = !config.cudaSupport;
  };
})
