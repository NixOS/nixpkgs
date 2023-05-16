{ lib
<<<<<<< HEAD
, blas
, buildPythonPackage
, setuptools
, importlib-metadata
=======
, absl-py
, blas
, buildPythonPackage
, etils
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, jaxlib
, jaxlib-bin
, lapack
, matplotlib
<<<<<<< HEAD
, ml-dtypes
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, numpy
, opt-einsum
, pytestCheckHook
, pytest-xdist
, pythonOlder
, scipy
, stdenv
<<<<<<< HEAD
=======
, typing-extensions
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "0.4.14";
  format = "pyproject";

  disabled = pythonOlder "3.9";
=======
  version = "0.4.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    # google/jax contains tags for jax and jaxlib. Only use jax tags!
    rev = "refs/tags/${pname}-v${version}";
<<<<<<< HEAD
    hash = "sha256-0KnILQkahSiA1uuyT+kgy1XaCcZ3cpx1q114e2pecvg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

=======
    hash = "sha256-UJzX8zP3qaEUIV5hPJhiGiLJO7k8p962MHWxIHDY1ZA=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # jaxlib is _not_ included in propagatedBuildInputs because there are
  # different versions of jaxlib depending on the desired target hardware. The
  # JAX project ships separate wheels for CPU, GPU, and TPU.
  propagatedBuildInputs = [
<<<<<<< HEAD
    ml-dtypes
    numpy
    opt-einsum
    scipy
  ] ++ lib.optional (pythonOlder "3.10") importlib-metadata;
=======
    absl-py
    etils
    numpy
    opt-einsum
    scipy
    typing-extensions
  ] ++ etils.optional-dependencies.epath;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [
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
  ] ++ lib.optionals usingMKL [
    # See
    #  * https://github.com/google/jax/issues/9705
    #  * https://discourse.nixos.org/t/getting-different-results-for-the-same-build-on-two-equally-configured-machines/17921
    #  * https://github.com/NixOS/nixpkgs/issues/161960
    "test_custom_linear_solve_cholesky"
    "test_custom_root_with_aux"
    "testEigvalsGrad_shape"
<<<<<<< HEAD
  ] ++ lib.optionals stdenv.isAarch64 [
=======
  ] ++ lib.optionals (stdenv.isAarch64 && stdenv.isDarwin) [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # See https://github.com/google/jax/issues/14793.
    "test_for_loop_fixpoint_correctly_identifies_loop_varying_residuals_unrolled_for_loop"
    "testQdwhWithRandomMatrix3"
    "testScanGrad_jit_scan"
  ];

<<<<<<< HEAD
  disabledTestPaths = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # RuntimeWarning: invalid value encountered in cast
    "tests/lax_test.py"
  ];

  pythonImportsCheck = [ "jax" ];
=======
  # See https://github.com/google/jax/issues/11722. This is a temporary fix in
  # order to unblock etils, and upgrading jax/jaxlib to the latest version. See
  # https://github.com/NixOS/nixpkgs/issues/183173#issuecomment-1204074993.
  disabledTestPaths = [
    "tests/api_test.py"
    "tests/core_test.py"
    "tests/lax_numpy_indexing_test.py"
    "tests/lax_numpy_test.py"
    "tests/nn_test.py"
    "tests/random_test.py"
    "tests/sparse_test.py"
  ];

  # As of 0.3.22, `import jax` does not work without jaxlib being installed.
  pythonImportsCheck = [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Differentiate, compile, and transform Numpy code";
    homepage = "https://github.com/google/jax";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
