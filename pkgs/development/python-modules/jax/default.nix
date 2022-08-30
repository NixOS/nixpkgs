{ lib
, absl-py
, blas
, buildPythonPackage
, etils
, fetchFromGitHub
, jaxlib
, lapack
, matplotlib
, numpy
, opt-einsum
, pytestCheckHook
, pytest-xdist
, pythonOlder
, scipy
, typing-extensions
}:

let
  usingMKL = blas.implementation == "mkl" || lapack.implementation == "mkl";
in
buildPythonPackage rec {
  pname = "jax";
  version = "0.3.16";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "jax-v${version}";
    hash = "sha256-4idh7boqBXSO9vEHxEcrzXjBIrKmmXiCf6cXh7En1/I=";
  };

  # jaxlib is _not_ included in propagatedBuildInputs because there are
  # different versions of jaxlib depending on the desired target hardware. The
  # JAX project ships separate wheels for CPU, GPU, and TPU. Currently only the
  # CPU wheel is packaged.
  propagatedBuildInputs = [
    absl-py
    etils
    numpy
    opt-einsum
    scipy
    typing-extensions
  ] ++ etils.optional-dependencies.epath;

  checkInputs = [
    jaxlib
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
  ] ++ lib.optionals usingMKL [
    # See
    #  * https://github.com/google/jax/issues/9705
    #  * https://discourse.nixos.org/t/getting-different-results-for-the-same-build-on-two-equally-configured-machines/17921
    #  * https://github.com/NixOS/nixpkgs/issues/161960
    "test_custom_linear_solve_cholesky"
    "test_custom_root_with_aux"
    "testEigvalsGrad_shape"
  ];

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

  pythonImportsCheck = [
    "jax"
  ];

  meta = with lib; {
    description = "Differentiate, compile, and transform Numpy code";
    homepage = "https://github.com/google/jax";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
