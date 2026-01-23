{
  lib,
  aiomisc,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pytest,
}:

buildPythonPackage rec {
  pname = "aiomisc-pytest";
  version = "1.3.4";
  pyproject = true;

  src = fetchPypi {
    pname = "aiomisc_pytest";
    inherit version;
    hash = "sha256-9Of1pSUcMiIhkz7OW5erF4oDlf/ABkaamDBPg7+WbBE=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "pytest" ];

  buildInputs = [ pytest ];

  dependencies = [ aiomisc ];

  pythonImportsCheck = [ "aiomisc_pytest" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Pytest integration for aiomisc";
    homepage = "https://github.com/aiokitchen/aiomisc-pytest";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
