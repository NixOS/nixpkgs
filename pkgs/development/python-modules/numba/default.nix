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
  # Run the CUDA tests on a machine with a GPU (requires `programs.nix-required-mounts`)
  doGpuCheck ? false,
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

  libCudaDir =
    # Use cuda_compat to provide libcuda.so from its `compat` directory
    if (cudaPackages.cuda_compat.meta.available or false) then
      "${cudaPackages.cuda_compat}/compat"
    # Else, use the host CUDA driver library
    else
      "${addDriverRunpath.driverLink}/lib";
in
buildPythonPackage (finalAttrs: {
  version = "0.68.1";
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
    hash = "sha256-HGPXdaGtX9sNU9UsLUenazGyf9oUTzD1ocrG+DID+6w=";
  };

  patches = lib.optionals cudaSupport [
    # Hardcode the paths of the NVIDIA libraries which numba looks up at runtime, instead of
    # relying on its discovery heuristics (conda environment, `CUDA_HOME`, `/usr/local/cuda`, ...)
    (replaceVars ./nvidia-libs-paths.patch {
      libcuda = libCudaDir;
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
  ''
  # Without a device, numba falls back to compute_50, which CUDA >= 13 does not support:
  # libnvvm : error: -arch=compute_50 is an unsupported option
  + lib.optionalString (cudaSupport && cudaPackages.cudaAtLeast "13.0") ''
    export NUMBA_CUDA_DEFAULT_PTX_CC=7.5
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

  pytestFlags = [
    # pytest's assertion rewriting injects calls that numba cannot compile in nopython mode:
    # Unknown attribute '_call_reprcompare' of type Module(<module '_pytest.assertion.rewrite'>)
    "--assert=plain"
    # pytest's unraisable exception hook prevents some tests from checking stderr
    "-p"
    "no:unraisableexception"
  ];

  disabledTests = [
    # Assume NUMBA_NUM_THREADS > 1, but checkPhaseThreadLimitHook sets it to 1
    "TestParforReductionSetNumThreads"

    # Flaky: RuntimeError: Instruction does not dominate all uses!
    "test_1d_slicing_set_tuple_npm"

    # Requires pip
    "test_has_no_error"

    # Failed: Unexpected success
    "test_reproducible_build_jitclass"
    "test_reproducible_build_recursive_type"
    "test_reproducible_build_stencil"
  ]
  ++ lib.optionals (cudaSupport && cudaPackages.cudaAtLeast "13.0") [
    # Hardcode compute capabilities that CUDA >= 13 does not support
    "test_fp16_abs_ptx"
    "test_fp16_binary_ptx"
    "test_fp16_comparison_ptx"
    "test_fp16_inplace_binary_ptx"
    "test_fp16_int8_comparison_ptx"
    "test_fp16_neg_ptx"
    "test_get_arch_option"
    "test_habs_ptx"
    "test_hadd_ptx"
    "test_hfma_ptx"
    "test_hmul_ptx"
    "test_hneg_ptx"
    "test_hsub_ptx"
    "test_linker_basic"
    "test_mixed_fp16_comparison_promotion_ptx"
    "test_nanosleep"
    "test_nvvm_compile_nullary_option"
    "test_tanhf_compile_ptx"

    # AssertionError: 'red.add.f64' not found in [PTX]
    # Recent NVVM emits atom.global.add.f64 instead
    "test_atomic_add_double"
  ]
  ++ lib.optionals doGpuCheck [
    # NotImplementedError: (3, 14)
    "TestDebugOutput"

    # TypingError: Unknown attribute 'append' of type list(undefined)
    "test_fancy_creation_readout"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # captured stderr: Fatal Python error: Segmentation fault
    "test_sum1d_pyobj"
  ];

  disabledTestPaths = [
    # Module-level helper functions named test_* are not tests:
    # fixture 'b' not found
    "${python.sitePackages}/numba/tests/test_copy_propagate.py::test_will_propagate"
    "${python.sitePackages}/numba/tests/test_copy_propagate.py::test_wont_propagate"
    "${python.sitePackages}/numba/tests/test_parfors.py::test_call_hoisting_outcall"
    "${python.sitePackages}/numba/tests/test_remove_dead.py::test_will_propagate"
    "${python.sitePackages}/numba/tests/test_tracing.py::test"
  ]
  ++ lib.optionals (!doGpuCheck) [
    # Require a GPU, see passthru.tests.gpuCheck
    "${python.sitePackages}/numba/cuda/tests"
  ]
  ++ lib.optionals doGpuCheck [
    # Module-level helper functions named test_* are not tests:
    # fixture 'r' not found
    "${python.sitePackages}/numba/cuda/tests/cudapy/test_intrinsics.py::test_multiple_hcmp_1"
    "${python.sitePackages}/numba/cuda/tests/cudapy/test_intrinsics.py::test_multiple_hcmp_2"
    "${python.sitePackages}/numba/cuda/tests/cudapy/test_intrinsics.py::test_multiple_hcmp_3"
    "${python.sitePackages}/numba/cuda/tests/cudapy/test_intrinsics.py::test_multiple_hcmp_4"
    "${python.sitePackages}/numba/cuda/tests/cudapy/test_intrinsics.py::test_multiple_hcmp_5"
    "${python.sitePackages}/numba/cuda/tests/cudapy/test_operator.py::test_multiple_hcmp_1"
    "${python.sitePackages}/numba/cuda/tests/cudapy/test_operator.py::test_multiple_hcmp_2"
    "${python.sitePackages}/numba/cuda/tests/cudapy/test_operator.py::test_multiple_hcmp_3"
    "${python.sitePackages}/numba/cuda/tests/cudapy/test_operator.py::test_multiple_hcmp_4"
    "${python.sitePackages}/numba/cuda/tests/cudapy/test_operator.py::test_multiple_hcmp_5"

    # Two-argument max/min fail to compile on CUDA:
    # TypeError: Signature mismatch: 2 argument types given, but function takes 1 arguments
    # https://github.com/numba/numba/issues/10753
    "${python.sitePackages}/numba/cuda/tests/cudapy/test_cuda_array_interface.py::TestCudaArrayInterface::test_gufunc_arg"
    "${python.sitePackages}/numba/cuda/tests/cudapy/test_datetime.py::TestCudaDateTime::test_gufunc"
    "${python.sitePackages}/numba/cuda/tests/cudapy/test_gufunc.py"
    "${python.sitePackages}/numba/cuda/tests/cudapy/test_gufunc_scalar.py"
    "${python.sitePackages}/numba/cuda/tests/cudapy/test_minmax.py"
    "${python.sitePackages}/numba/cuda/tests/cudapy/test_reduction.py::TestReduction::test_max_reduce"
  ];

  requiredSystemFeatures = lib.optionals doGpuCheck [ "cuda" ];

  pythonImportsCheck = [ "numba" ];

  passthru.testers.cuda-detect =
    writers.writePython3Bin "numba-cuda-detect"
      { libraries = [ (numba.override { cudaSupport = true; }) ]; }
      ''
        from numba import cuda
        cuda.detect()
      '';
  passthru.tests = {
    gpuCheck = numba.override {
      cudaSupport = true;
      doFullCheck = true;
      doGpuCheck = true;
    };
    withSandbox = numba.override {
      cudaSupport = false;
      doFullCheck = true;
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
