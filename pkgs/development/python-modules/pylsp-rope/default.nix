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
  version = "0.1.16";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1oC2iMYKQCV6iELsgIpuDeFZakelMA8irs/caVVQIKc=";
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
