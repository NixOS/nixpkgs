{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest8_3CheckHook,
}:

buildPythonPackage rec {
  pname = "esprima";
  version = "4.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Kronuz";
    repo = "esprima-python";
    rev = "v${version}";
    sha256 = "WtkPCReXhxyr6pOzE9gsdIeBlLk+nSnbxkS3OowEaHo=";
  };

  nativeCheckInputs = [ pytest8_3CheckHook ];

  enabledTestPaths = [ "test/__main__.py::TestEsprima" ];

  pythonImportsCheck = [ "esprima" ];

  meta = {
    description = "Python parser for standard-compliant ECMAScript";
    mainProgram = "esprima";
    homepage = "https://github.com/Kronuz/esprima-python";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
