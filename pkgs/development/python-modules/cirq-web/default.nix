{ buildPythonPackage
, cirq-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cirq-web";
  format = "setuptools";
  inherit (cirq-core) version src meta;

  sourceRoot = "${src.name}/${pname}";

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
