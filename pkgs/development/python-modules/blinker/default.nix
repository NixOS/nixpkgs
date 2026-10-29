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

buildPythonPackage (finalAttrs: {
  pname = "blinker";
  version = "1.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-tM4iZaer7ORefMiW6Y2+vmzq1WvPgFo9IxNtFF9URb8=";
  };

  build-system = [ flit-core ];

  pythonImportsCheck = [ "blinker" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/pallets-eco/blinker/releases/tag/${finalAttrs.version}";
    description = "Fast Python in-process signal/event dispatching system";
    homepage = "https://github.com/pallets-eco/blinker/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
