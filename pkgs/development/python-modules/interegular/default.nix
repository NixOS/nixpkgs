{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "interegular";
  version = "0.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-2baXshs0iEcROZug8DdpFLgYmc5nADJIbQ0Eg0SnZgA=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "interegular" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Library to check a subset of python regexes for intersections";
    homepage = "https://github.com/MegaIng/interegular";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lach ];
  };
})
