{ lib
, absl-py
, blas
, buildPythonPackage
, fetchFromGitHub
, jaxlib
, lapack
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
  version = "0.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "jax-v${version}";
    sha256 = "sha256-RZqSJP2vtt8U6nmftV2VzfkMGkkk3100QqsjI7PpQbc=";
  };

  patches = [
    # See https://github.com/google/jax/issues/7944
    ./cache-fix.patch
  ];

  # jaxlib is _not_ included in propagatedBuildInputs because there are
  # different versions of jaxlib depending on the desired target hardware. The
  # JAX project ships separate wheels for CPU, GPU, and TPU. Currently only the
  # CPU wheel is packaged.
  propagatedBuildInputs = [
    absl-py
    numpy
    opt-einsum
    scipy
    typing-extensions
  ];

  checkInputs = [
    jaxlib
    pytestCheckHook
    pytest-xdist
  ];

  # NOTE: Don't run the tests in the expiremental directory as they require flax
  # which creates a circular dependency. See https://discourse.nixos.org/t/how-to-nix-ify-python-packages-with-circular-dependencies/14648/2.
  # Not a big deal, this is how the JAX docs suggest running the test suite
  # anyhow.
  pytestFlagsArray = [
    "-n auto"
    "-W ignore::DeprecationWarning"
    "tests/"
  ];

  # See
  #  * https://github.com/google/jax/issues/9705
  #  * https://discourse.nixos.org/t/getting-different-results-for-the-same-build-on-two-equally-configured-machines/17921
  #  * https://github.com/NixOS/nixpkgs/issues/161960
  disabledTests = lib.optionals usingMKL [
    "test_custom_linear_solve_cholesky"
    "test_custom_root_with_aux"
    "testEigvalsGrad_shape"
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
