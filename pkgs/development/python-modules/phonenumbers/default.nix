{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "phonenumbers";
  version = "9.0.37";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-iSOrQTxXWyfaKBXJvvSCkBgaq1ZTmLXn4jzHrOISopM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/*.py" ];

  pythonImportsCheck = [ "phonenumbers" ];

  meta = {
    description = "Python module for handling international phone numbers";
    homepage = "https://github.com/daviddrysdale/python-phonenumbers";
    changelog = "https://github.com/daviddrysdale/python-phonenumbers/blob/v${finalAttrs.version}/python/HISTORY.md";
    license = lib.licenses.asl20;
  };
})
