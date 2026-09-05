{
  lib,
  config,
  stdenv,
  blas,
  lapack,
  buildPythonPackage,
  fetchFromGitHub,
  cudaSupport ? config.cudaSupport,
  cudaPackages,

  # build-system
  setuptools,

  # dependencies
  jaxlib,
  ml-dtypes,
  numpy,
  opt-einsum,
  scipy,

  # optional-dependencies
  jax-cuda12-plugin,
  jax-cuda13-plugin,

  # tests
  absl-py,
  cloudpickle,
  flatbuffers,
  hypothesis,
  matplotlib,
  pytestCheckHook,
  pytest-xdist,

  # passthru
  callPackage,
  jax,
  jaxlib-build,
  jaxlib-bin,
}:

let
  usingMKL = blas.implementation == "mkl" || lapack.implementation == "mkl";
in
buildPythonPackage (finalAttrs: {
  pname = "jax";
  version = "0.11.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "jax";
    # google/jax contains tags for jax and jaxlib. Only use jax tags!
    tag = "jax-v${finalAttrs.version}";
    hash = "sha256-OiH4qhVK7T6o+lYtP1e2UqtSitxVdzUWC5YXbaNMZsQ=";
  };

  build-system = [ setuptools ];

  # The version is automatically set to ".dev" if this variable is not set.
  # https://github.com/google/jax/commit/e01f2617b85c5bdffc5ffb60b3d8d8ca9519a1f3
  env.JAX_RELEASE = "1";

  dependencies = [
    jaxlib
    ml-dtypes
    numpy
    opt-einsum
    scipy
  ]
  ++ lib.optionals cudaSupport finalAttrs.passthru.optional-dependencies.cuda;

  optional-dependencies =
    let
      inherit (cudaPackages) cudaMajorVersion;
      cuda12 = [ jax-cuda12-plugin ];
      cuda13 = [ jax-cuda13-plugin ];
    in
    {
      cuda =
        if cudaMajorVersion == "12" then
          cuda12
        else if cudaMajorVersion == "13" then
          cuda13
        else
          throw "Unsupported cudaPackages version (${cudaMajorVersion}). Supported versions are 12 and 13.";
      cuda12 = cuda12;
      cuda12_local = cuda12;
      cuda13 = cuda13;
      cuda13_local = cuda13;
    };

  nativeCheckInputs = [
    absl-py
    cloudpickle
    flatbuffers
    hypothesis
    matplotlib
    pytestCheckHook
    pytest-xdist
  ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  # NOTE: Don't run the tests in the experimental directory as they require flax
  # which creates a circular dependency. See https://discourse.nixos.org/t/how-to-nix-ify-python-packages-with-circular-dependencies/14648/2.
  # Not a big deal, this is how the JAX docs suggest running the test suite
  # anyhow.
  enabledTestPaths = [
    "tests/"
  ];

  preCheck =
    # Prevents `tests/export_back_compat_test.py::CompatTest::test_*` tests from failing on darwin with
    # PermissionError: [Errno 13] Permission denied: '/tmp/back_compat_testdata/test_*.py'
    # See https://github.com/google/jax/blob/jaxlib-v0.4.27/jax/_src/internal_test_util/export_back_compat_test_util.py#L240-L241
    # NOTE: this doesn't seem to be an issue on linux
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      export TEST_UNDECLARED_OUTPUTS_DIR=$(mktemp -d)
    ''
    # Disable CUDA during tests when cudaSupport is enabled but no GPU is available
    + lib.optionalString cudaSupport ''
      export JAX_PLATFORMS=cpu
    '';

  disabledTests = [
    # Exceeds tolerance when the machine is busy
    "test_custom_linear_solve_aux"

    # pytest-xdist/execnet cannot serialize the numpy `type` objects this test passes to
    # self.subTest(dtype=...) when shipping subtest reports between workers.
    # The assertions themselves pass; the failure is a harness artifact of running with
    # --numprocesses.
    # New test in jax 0.10.2 (tests/random_impl_test.py).
    "test_random_bits"
  ]
  ++ lib.optionals usingMKL [
    # See
    #  * https://github.com/google/jax/issues/9705
    #  * https://discourse.nixos.org/t/getting-different-results-for-the-same-build-on-two-equally-configured-machines/17921
    #  * https://github.com/NixOS/nixpkgs/issues/161960
    "test_custom_linear_solve_cholesky"
    "test_custom_root_with_aux"
    "testEigvalsGrad_shape"
  ]
  ++ lib.optionals cudaSupport [
    # AssertionError: 'INFO' not found in "DEBUG:2026-09-05 10:11:42,262:jax._src.path:40: etils.epath was not found...
    "test_subprocess_stderr_debug_logging"

    # AssertionError: 'INFO' not found in 'I0905 10:11:44.349869   24500 pjrt_api.cc:119] GetPjrtApi was found for cuda at...
    "test_subprocess_stderr_info_logging"
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    # The Mosaic GPU interpreter emulates tcgen05 MMA on the CPU backend and compares the
    # result with `assert_array_equal`. On x86_64 the two sides contract differently and
    # disagree by a single float32 ULP (max relative difference 5.5e-07).
    # Passes on aarch64-linux and aarch64-darwin.
    "test_async_copy_tmem_with_mma"
    "test_can_commit_mma_to_multiple_barriers"
    "test_can_deallocate_tmem_while_mma_active_on_different_tmem"
    "test_can_pipeline_with_multiple_children"
    "test_can_pipeline_with_multiple_parents"
  ];

  pythonImportsCheck = [ "jax" ];

  # Test CUDA-enabled jax and jaxlib. Running CUDA-enabled tests is not
  # currently feasible within the nix build environment so we have to maintain
  # this script separately. See https://github.com/NixOS/nixpkgs/pull/256230
  # for a possible remedy to this situation.
  #
  # Run these tests with eg
  #
  #   NIXPKGS_ALLOW_UNFREE=1 nixglhost -- nix run --impure .#python3Packages.jax.passthru.tests.test_cuda_jaxlibBin
  passthru.tests = {
    # jaxlib-build is broken as of 2024-12-20
    # test_cuda_jaxlibSource = callPackage ./test-cuda.nix {
    #   jax = jax.override { jaxlib = jaxlib-build; };
    # };
    test_cuda_jaxlibBin = callPackage ./test-cuda.nix {
      jax = jax.override { jaxlib = jaxlib-bin; };
    };
  };

  # updater fails to pick the correct branch
  passthru.skipBulkUpdate = true;

  meta = {
    description = "Source-built JAX frontend: differentiate, compile, and transform Numpy code";
    homepage = "https://github.com/jax-ml/jax";
    changelog = "https://docs.jax.dev/en/latest/changelog.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      samuela
    ];
  };
})
