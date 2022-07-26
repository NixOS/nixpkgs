{ stdenv
, buildPythonPackage
, dm-haiku
, pytest-xdist
, pytestCheckHook
, tensorflow
, tensorflow-datasets
, flax
, optax
}:

buildPythonPackage rec {
  pname = "optax-tests";
  inherit (optax) version;

  src = optax.testsout;

  dontBuild = true;
  dontInstall = true;

  checkInputs = [
    dm-haiku
    pytest-xdist
    pytestCheckHook
    tensorflow
    tensorflow-datasets
    flax
  ];

  disabledTestPaths = [
    # See https://github.com/deepmind/optax/issues/323
    "examples/lookahead_mnist_test.py"
  ];

}
