{ buildPythonPackage
, cirq-core
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cirq-aqt";
  inherit (cirq-core) version src meta;

<<<<<<< HEAD
  sourceRoot = "${src.name}/${pname}";
=======
  sourceRoot = "source/${pname}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "requests~=2.18" "requests"
  '';

  propagatedBuildInputs = [
    cirq-core
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_aqt" ];

  disabledTestPaths = [
    # No need to test the version number
    "cirq_aqt/_version_test.py"
  ];
}
