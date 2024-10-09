{
  buildPythonPackage,
  cirq-core,
  requests,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cirq-aqt";
  pyproject = true;
  inherit (cirq-core) version src meta;

  sourceRoot = "${src.name}/${pname}";

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace-fail "requests~=2.18" "requests"
  '';

  build-system = [ setuptools ];

  dependencies = [
    cirq-core
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_aqt" ];

  disabledTestPaths = [
    # No need to test the version number
    "cirq_aqt/_version_test.py"
  ];
}
