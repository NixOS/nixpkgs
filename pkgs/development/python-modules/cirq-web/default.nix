{ buildPythonPackage
, cirq-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cirq-web";
  inherit (cirq-core) version src meta;

<<<<<<< HEAD
  sourceRoot = "${src.name}/${pname}";
=======
  sourceRoot = "source/${pname}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    cirq-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_web" ];

  disabledTestPaths = [
    # No need to test the version number
    "cirq_web/_version_test.py"
  ];
}
