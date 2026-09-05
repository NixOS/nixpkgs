{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "editables";
  version = "0.6";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-EWODSQI4HEYTeHlRxZFIAP3xVa4IhIo3O46lAGeAl3w=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests not included in archive.
  doCheck = false;

  pythonImportsCheck = [ "editables" ];

  __structuredAttrs = true;

  meta = {
    description = "Editable installations";
    homepage = "https://github.com/pfmoore/editables";
    changelog = "https://github.com/pfmoore/editables/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
  };
})
