{ lib
, buildPythonPackage
, fetchPypi
, rope
, pytestCheckHook
, python-lsp-server
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylsp-rope";
  version = "0.1.11";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SKrfmT2vpej8oRCLSlQxMUz4C8eM/91WQA6tnEB1U74=";
  };

  propagatedBuildInputs = [
    rope
    python-lsp-server
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pylsp_rope"
  ];

  meta = with lib; {
    description = "Extended refactoring capabilities for Python LSP Server using Rope";
    homepage = "https://github.com/python-rope/pylsp-rope";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
