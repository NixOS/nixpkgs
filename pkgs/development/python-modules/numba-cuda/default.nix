{
  lib,
  config,
  addDriverRunpath,
  buildPythonPackage,
  cudaPackages,
  fetchFromGitHub,
  python,
  runCommand,
  symlinkJoin,

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
  psutil,
  pytest-benchmark,
  pytest-subtests,
  pytestCheckHook,
}:

let
  # `libnvvm.so` and `libdevice.10.bc` are bundled in `cuda_nvcc` up to CUDA 12.x, and shipped as a
  # dedicated redistributable from CUDA 13.0 onwards
  nvvmRoot =
    if cudaPackages.cudaOlder "13.0" then
      "${lib.getLib cudaPackages.cuda_nvcc}/nvvm"
    else
      lib.getLib cudaPackages.libnvvm;

  libCudaPath =
    # Use cuda_compat to provide libcuda.so on pre-Thor Jetsons
    if (cudaPackages.cuda_compat.meta.available or false) then
      cudaPackages.cuda_compat
    # Else, use the host CUDA driver library
    else
      addDriverRunpath.driverLink;

  # `numba.cuda.cuda_paths` and `cuda.pathfinder` discover the CUDA components by walking a CUDA
  # toolkit root, which nixpkgs does not have. Assemble one with the layout they expect.
  cudaHome =
    let
      libs = symlinkJoin {
        name = "numba-cuda-libs";
        paths = with cudaPackages; [
          (lib.getLib cuda_cudart)
          (lib.getOutput "static" cuda_cudart)
          (lib.getLib cuda_nvrtc)
          (lib.getLib libnvjitlink)
        ];
      };
      includes = symlinkJoin {
        name = "numba-cuda-includes";
        paths = with cudaPackages; [
          (lib.getInclude cuda_cudart)
          # `cuda/atomic` & al., needed to compile the NRT headers with NVRTC
          (lib.getInclude cuda_cccl)
        ];
      };
    in
    runCommand "numba-cuda-home" { } ''
      mkdir -p $out/nvvm
      ln -s ${nvvmRoot}/lib $out/nvvm/lib64
      ln -s ${nvvmRoot}/libdevice $out/nvvm/libdevice
      ln -s ${libs}/lib $out/lib64
      ln -s ${includes}/include $out/include
    '';
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

  postPatch =
    # `np.row_stack` was removed in numpy 2.5. Same fix as `numba`'s `numpy2.5.patch`.
    ''
      substituteInPlace numba_cuda/numba/cuda/np/arrayobj.py \
        --replace-fail \
          "if numpy_version >= (2, 0):" \
          "if (2, 0) <= numpy_version < (2, 5):"
    ''
    # `libcuda.so` is looked up in hardcoded FHS directories, and upstream dropped the
    # `NUMBA_CUDA_DRIVER` override that used to allow pointing it elsewhere
    + ''
      substituteInPlace numba_cuda/numba/cuda/cudadrv/driver.py \
        --replace-fail \
          'dldir = ["/usr/lib", "/usr/lib64"]' \
          'dldir = ["${libCudaPath}/lib"]'
    ''
    # These are expanded at parse time even when overridden from the command line, which makes the
    # build log look like `make` failed when it did not.
    + ''
      substituteInPlace testing/Makefile \
        --replace-fail "GPU_CC := " "GPU_CC ?= " \
        --replace-fail "NRT_INCLUDE_DIR := " "NRT_INCLUDE_DIR ?= "
    ''
    # `determine_include_flags()` scrapes `nvcc -v` for a single `INCLUDES=` line and bails out on
    # anything else. nixpkgs' nvcc prints two, and neither carries the CUDA runtime headers, which
    # are passed through `NIX_CFLAGS_COMPILE` instead.
    + ''
      substituteInPlace testing/generate_raw_ltoir.py \
        --replace-fail \
          "cuda_include_flags = determine_include_flags() + (" \
          "cuda_include_flags = [\"-I${cudaHome}/include\"] + ("
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
    CUDA_HOME = "${cudaHome}";
    # No GPU in the sandbox, so only the CUDA simulator target can be exercised here. This mirrors
    # upstream's `ci/test_simulator.sh`. The real device suite is `passthru.gpuCheck`.
    NUMBA_ENABLE_CUDASIM = "1";
  };

  pythonImportsCheck = [
    "numba_cuda"
  ];

  nativeCheckInputs = [
    cffi
    filecheck
    ml-dtypes
    psutil
    pytest-benchmark
    pytest-subtests
    pytestCheckHook
  ];

  preCheck =
    # The tests must not be run from the source root: `numba_cuda/numba/` there shadows the
    # installed package. Upstream runs them from `testing/`, whose `pytest.ini` collects the
    # installed copy through `--pyargs numba.cuda.tests`.
    ''
      cd testing
      export NUMBA_CUDA_TEST_BIN_DIR="$PWD"
    ''
    # `numba.cuda` is redirected to `numba_cuda.numba.cuda` by a `.pth` file, which is only
    # honoured for `NIX_PYTHONPATH` entries and not for the `PYTHONPATH` one the install hook adds.
    + ''
      export NIX_PYTHONPATH="$out/${python.sitePackages}''${NIX_PYTHONPATH:+:$NIX_PYTHONPATH}"
    ''
    # pytest 9 no longer exposes fixtures from the rootdir `conftest.py` to tests collected from
    # outside of it (here: from site-packages), so it is loaded as a plugin instead (see
    # `pytestFlags` below).
    + ''
      mv conftest.py numba_cuda_pytest_plugin.py
    '';

  pytestFlags = [
    "-pnumba_cuda_pytest_plugin"
    # Upstream turns warnings into errors, which trips over unrelated deprecation warnings raised
    # by numba itself at import time.
    "-ofilterwarnings="
  ];

  disabledTests = [
    # Spawn a fresh interpreter, which does not go through `pytestFlags` and thus misses the
    # `numba.cuda` redirector.
    "test_dynamic_class_reset_on_unpickle_new_proc"
    "test_main_class_reset_on_unpickle"
  ];

  passthru.gpuCheck = finalAttrs.finalPackage.overrideAttrs (prevAttrs: {
    requiredSystemFeatures = [ "cuda" ];

    nativeBuildInputs = (prevAttrs.nativeBuildInputs or [ ]) ++ [ cudaPackages.cuda_nvcc ];

    # cuda_runtime.h, cuda_fp16.h
    buildInputs = (prevAttrs.buildInputs or [ ]) ++ [ cudaPackages.cuda_cudart ];

    env = prevAttrs.env // {
      NUMBA_ENABLE_CUDASIM = "0";
    };

    preCheck =
      prevAttrs.preCheck
      # Build the cubin/fatbin/LTO-IR fixtures that the `cudadrv` and `nrt` tests link against.
      # `make` shells out to `nvidia-smi` for the compute capability, which is unavailable in the
      # sandbox.
      + ''
        make GPU_CC=${lib.replaceStrings [ "." ] [ "" ] (lib.head cudaPackages.flags.cudaCapabilities)}
      '';
  });

  meta = {
    description = "The CUDA target for Numba";
    homepage = "https://github.com/NVIDIA/numba-cuda";
    changelog = "https://github.com/NVIDIA/numba-cuda/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    broken = !config.cudaSupport;
  };
})
