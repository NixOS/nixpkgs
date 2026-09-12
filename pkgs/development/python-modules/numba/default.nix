{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  replaceVars,

  # nativeBuildInputs
  setuptools,

  # sets NUMBA_NUM_THREADS and OMP_NUM_THREADS for packages
  # invoking numba during checkPhase/installCheckPhase to
  # avoid overloading builders with excessive parallelism
  # See also: https://numba.readthedocs.io/en/stable/reference/envvars.html#threading-control
  checkPhaseThreadLimitHook,

  # dependencies
  llvmlite,
  numpy,

  # tests
  numba,
  pytestCheckHook,
  pytest-xdist,
  writableTmpDirAsHomeHook,
  writers,
  python,

  # CUDA-only dependencies:
  addDriverRunpath,
  autoAddDriverRunpath,
  cudaPackages,

  # CUDA flags:
  config,
  cudaSupport ? config.cudaSupport,
  testsWithoutSandbox ? false,
  doFullCheck ? false,
}:

let
  # `libnvvm.so` and `libdevice.10.bc` are bundled in `cuda_nvcc` up to CUDA 12.x, and shipped as a
  # dedicated redistributable from CUDA 13.0 onwards
  nvvmRoot =
    if cudaPackages.cudaOlder "13.0" then
      "${lib.getLib cudaPackages.cuda_nvcc}/nvvm"
    else
      "${lib.getLib cudaPackages.libnvvm}";

  libCudaPath =
    # Use cuda_compat to provide libcuda.so on pre-Thor Jetsons
    if (cudaPackages.cuda_compat.meta.available or false) then
      cudaPackages.cuda_compat
    # Else, use the host CUDA driver library
    else
      addDriverRunpath.driverLink;
in
buildPythonPackage (finalAttrs: {
  version = "0.67.0";
  pname = "numba";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "numba";
    repo = "numba";
    tag = finalAttrs.version;
    # Upstream uses .gitattributes to inject information about the revision
    # hash and the refname into `numba/_version.py`, see:
    #
    # - https://git-scm.com/docs/gitattributes#_export_subst and
    # - https://github.com/numba/numba/blame/5ef7c86f76a6e8cc90e9486487294e0c34024797/numba/_version.py#L25-L31
    postFetch = ''
      sed -i 's/git_refnames = "[^"]*"/git_refnames = " (tag: ${finalAttrs.src.tag})"/' $out/numba/_version.py
    '';
    hash = "sha256-xQFJSO9kcRwyNx/G/ALQXZWE6+4wL1Dz+5kIDXK5Eow=";
  };

  patches = lib.optionals cudaSupport [
    # Hardcode the paths of the NVIDIA libraries which numba looks up at runtime, instead of
    # relying on its discovery heuristics (conda environment, `CUDA_HOME`, `/usr/local/cuda`, ...)
    (replaceVars ./nvidia-libs-paths.patch {
      libcuda = libCudaPath;
      libcudart = lib.getLib cudaPackages.cuda_cudart;
      libcudart_static = lib.getOutput "static" cudaPackages.cuda_cudart;
      libnvrtc = lib.getLib cudaPackages.cuda_nvrtc;
      libnvvm = nvvmRoot;
    })
  ];

  build-system = [
    setuptools
    numpy
  ];

  nativeBuildInputs = lib.optionals cudaSupport [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
  ];

  buildInputs = lib.optionals cudaSupport [ cudaPackages.cuda_cudart ];

  dependencies = [
    numpy
    llvmlite
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    writableTmpDirAsHomeHook
  ];

  propagatedNativeBuildInputs = [
    checkPhaseThreadLimitHook
  ];

  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    cd $out
  '';

  enabledTestPaths =
    if doFullCheck then
      null
    else
      [
        # These are the most basic tests. Running all tests is too expensive, and
        # some of them fail (also differently on different platforms), so it will
        # be too hard to maintain such a `disabledTests` list.
        "${python.sitePackages}/numba/tests/test_usecases.py"
      ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # captured stderr: Fatal Python error: Segmentation fault
    "test_sum1d_pyobj"
  ];

  disabledTestPaths = lib.optionals (!testsWithoutSandbox) [
    # See NOTE near passthru.tests.withoutSandbox
    "${python.sitePackages}/numba/cuda/tests"
  ];

  pythonImportsCheck = [ "numba" ];

  passthru.testers.cuda-detect =
    writers.writePython3Bin "numba-cuda-detect"
      { libraries = [ (numba.override { cudaSupport = true; }) ]; }
      ''
        from numba import cuda
        cuda.detect()
      '';
  passthru.tests = {
    # CONTRIBUTOR NOTE: numba also contains CUDA tests, though these cannot be run in
    # this sandbox environment. Consider building the derivation below with
    # --no-sandbox to get a view of how many tests succeed outside the sandbox.
    withoutSandbox = numba.override {
      doFullCheck = true;
      cudaSupport = true;
      testsWithoutSandbox = true;
    };
    withSandbox = numba.override {
      cudaSupport = false;
      doFullCheck = true;
      testsWithoutSandbox = false;
    };
  };

  meta = {
    changelog = "https://numba.readthedocs.io/en/stable/release/${finalAttrs.version}-notes.html";
    description = "Compiling Python code using LLVM";
    homepage = "https://numba.pydata.org/";
    license = lib.licenses.bsd2;
    mainProgram = "numba";
  };
})
