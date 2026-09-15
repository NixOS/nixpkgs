{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  mergedict,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "configclass";
  version = "0.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-aoDKBuDxJCeXbVwCXhse6FCbDDM30/Xa8p9qRvDkWBk=";
  };

  build-system = [ setuptools ];

  dependencies = [ mergedict ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "configclass" ];

  meta = {
    description = "Python to class to hold configuration values";
    homepage = "https://github.com/schettino72/configclass/";
    changelog = "https://github.com/schettino72/configclass/blob/${finalAttrs.version}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
})
