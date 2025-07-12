{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  flit-core,

  # tests
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "blinker";
  version = "1.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tM4iZaer7ORefMiW6Y2+vmzq1WvPgFo9IxNtFF9URb8=";
  };

  build-system = [ flit-core ];

  pythonImportsCheck = [ "blinker" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/pallets-eco/blinker/releases/tag/${version}";
    description = "Fast Python in-process signal/event dispatching system";
    homepage = "https://github.com/pallets-eco/blinker/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
