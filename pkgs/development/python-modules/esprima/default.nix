{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "esprima";
  version = "4.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Kronuz";
    repo = "esprima-python";
    rev = "v${version}";
    sha256 = "WtkPCReXhxyr6pOzE9gsdIeBlLk+nSnbxkS3OowEaHo=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "test/__main__.py::TestEsprima" ];

  pythonImportsCheck = [ "esprima" ];

  meta = with lib; {
    description = "Python parser for standard-compliant ECMAScript";
    mainProgram = "esprima";
    homepage = "https://github.com/Kronuz/esprima-python";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
