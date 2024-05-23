{
  buildPythonPackage,
  cirq-core,
  requests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cirq-pasqal";
  format = "setuptools";
  inherit (cirq-core) version src meta;

  sourceRoot = "${src.name}/${pname}";

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "requests~=2.18" "requests"
  '';

  propagatedBuildInputs = [
    cirq-core
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_pasqal" ];

  disabledTestPaths = [
    # No need to test the version number
    "cirq_pasqal/_version_test.py"
  ];
}
