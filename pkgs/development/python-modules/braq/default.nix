{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "braq";
  version = "0.0.12";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-UdrlG4Y8u6LNN9oWPfBrfcUSSQTSwmuSvaVMG95m10s=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "braq" ];

  meta = {
    description = "Section-based human-readable data format";
    homepage = "https://github.com/pyrustic/braq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
