{ absl-py
, buildPythonPackage
, chex
, dm-haiku
, fetchFromGitHub
, jaxlib
, lib
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "optax";
  # As of 2022-01-06, the latest stable version (0.1.0) has broken tests that are fixed
  # in https://github.com/deepmind/optax/commit/d6633365d84eb6f2c0df0c52b630481a349ce562
  version = "unstable-2022-01-05";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "5ec5541b3486224b22e950480ff639ceaf5098f7";
    sha256 = "1q8cxc42a5xais2ll1l238cnn3l7w28savhgiz0lg01ilz2ysbli";
  };

  buildInputs = [ jaxlib ];

  propagatedBuildInputs = [
    absl-py
    chex
    numpy
  ];

  checkInputs = [
    dm-haiku
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "optax"
  ];

  disabledTestPaths = [
    # Requires `flax` which depends on `optax` creating circular dependency.
    "optax/_src/equivalence_test.py"
    # Require `tensorflow_datasets` which isn't packaged in `nixpkgs`.
    "examples/datasets_test.py"
    "examples/lookahead_mnist_test.py"
  ];

  meta = with lib; {
    description = "Optax is a gradient processing and optimization library for JAX.";
    homepage = "https://github.com/deepmind/optax";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
