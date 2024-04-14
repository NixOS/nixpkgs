{ lib
, blas
, buildPythonPackage
, callPackage
, setuptools
, importlib-metadata
, fetchFromGitHub
, jaxlib
, jaxlib-bin
, hypothesis
, lapack
, matplotlib
, ml-dtypes
, numpy
, opt-einsum
, pytestCheckHook
, pytest-xdist
, pythonOlder
, scipy
, stdenv
}:

let
  usingMKL = blas.implementation == "mkl" || lapack.implementation == "mkl";
  # jaxlib is broken on aarch64-* as of 2023-03-05, but the binary wheels work
  # fine. jaxlib is only used in the checkPhase, so switching backends does not
  # impact package behavior. Get rid of this once jaxlib is fixed on aarch64-*.
  jaxlib' = if jaxlib.meta.broken then jaxlib-bin else jaxlib;
in
buildPythonPackage rec {
  pname = "jax";
  version = "0.4.25";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "google";
    repo = "jax";
    # google/jax contains tags for jax and jaxlib. Only use jax tags!
    rev = "refs/tags/jax-v${version}";
    hash = "sha256-poQQo2ZgEhPYzK3aCs+BjaHTNZbezJAECd+HOdY1Yok=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # The version is automatically set to ".dev" if this variable is not set.
  # https://github.com/google/jax/commit/e01f2617b85c5bdffc5ffb60b3d8d8ca9519a1f3
  JAX_RELEASE = "1";

  # jaxlib is _not_ included in propagatedBuildInputs because there are
  # different versions of jaxlib depending on the desired target hardware. The
  # JAX project ships separate wheels for CPU, GPU, and TPU.
  propagatedBuildInputs = [
    ml-dtypes
    numpy
    opt-einsum
    scipy
  ] ++ lib.optional (pythonOlder "3.10") importlib-metadata;

  nativeCheckInputs = [
    hypothesis
    jaxlib'
    matplotlib
    pytestCheckHook
    pytest-xdist
  ];

  # high parallelism will result in the tests getting stuck
  dontUsePytestXdist = true;

  # NOTE: Don't run the tests in the expiremental directory as they require flax
  # which creates a circular dependency. See https://discourse.nixos.org/t/how-to-nix-ify-python-packages-with-circular-dependencies/14648/2.
  # Not a big deal, this is how the JAX docs suggest running the test suite
  # anyhow.
  pytestFlagsArray = [
    "--numprocesses=4"
    "-W ignore::DeprecationWarning"
    "tests/"
  ];

  disabledTests = [
    # Exceeds tolerance when the machine is busy
    "test_custom_linear_solve_aux"
    # UserWarning: Explicitly requested dtype <class 'numpy.float64'>
    #  requested in astype is not available, and will be truncated to
    # dtype float32. (With numpy 1.24)
    "testKde3"
    "testKde5"
    "testKde6"
    # Invokes python manually in a subprocess, which does not have the correct dependencies
    # ImportError: This version of jax requires jaxlib version >= 0.4.19.
    "test_no_log_spam"
  ] ++ lib.optionals usingMKL [
    # See
    #  * https://github.com/google/jax/issues/9705
    #  * https://discourse.nixos.org/t/getting-different-results-for-the-same-build-on-two-equally-configured-machines/17921
    #  * https://github.com/NixOS/nixpkgs/issues/161960
    "test_custom_linear_solve_cholesky"
    "test_custom_root_with_aux"
    "testEigvalsGrad_shape"
  ] ++ lib.optionals stdenv.isAarch64 [
    # See https://github.com/google/jax/issues/14793.
    "test_for_loop_fixpoint_correctly_identifies_loop_varying_residuals_unrolled_for_loop"
    "testQdwhWithRandomMatrix3"
    "testScanGrad_jit_scan"

    # See https://github.com/google/jax/issues/17867.
    "test_array"
    "test_async"
    "test_copy0"
    "test_device_put"
    "test_make_array_from_callback"
    "test_make_array_from_single_device_arrays"

    # Fails on some hardware due to some numerical error
    # See https://github.com/google/jax/issues/18535
    "testQdwhWithOnRankDeficientInput5"
  ];

  disabledTestPaths = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # RuntimeWarning: invalid value encountered in cast
    "tests/lax_test.py"
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
    test_cuda_jaxlibSource = callPackage ./test-cuda.nix {
      jaxlib = jaxlib.override { cudaSupport = true; };
    };
    test_cuda_jaxlibBin = callPackage ./test-cuda.nix {
      jaxlib = jaxlib-bin.override { cudaSupport = true; };
    };
  };

  # updater fails to pick the correct branch
  passthru.skipBulkUpdate = true;

  meta = with lib; {
    description = "Differentiate, compile, and transform Numpy code";
    homepage = "https://github.com/google/jax";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
