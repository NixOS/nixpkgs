<<<<<<< HEAD
{ buildPythonPackage
=======
{ stdenv
, buildPythonPackage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, dm-haiku
, pytest-xdist
, pytestCheckHook
, tensorflow
, tensorflow-datasets
, flax
, optax
}:

<<<<<<< HEAD
buildPythonPackage {
=======
buildPythonPackage rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "optax-tests";
  inherit (optax) version;

  src = optax.testsout;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
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
<<<<<<< HEAD
=======

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
