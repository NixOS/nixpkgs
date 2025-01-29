{
  lib,
  aiomisc,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pytest,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiomisc-pytest";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "aiomisc_pytest";
    inherit version;
    hash = "sha256-4mWP77R3CoX+XhoT6BbxQtxpINpdmeozjYUsegNfMyU=";
  };

  build-system = [ poetry-core ];


  pythonRelaxDeps = [ "pytest" ];

  buildInputs = [ pytest ];

  dependencies = [ aiomisc ];

  pythonImportsCheck = [ "aiomisc_pytest" ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Pytest integration for aiomisc";
    homepage = "https://github.com/aiokitchen/aiomisc-pytest";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
