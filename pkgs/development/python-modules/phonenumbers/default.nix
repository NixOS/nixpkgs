{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "9.0.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wtFaap0FNLFKd2T1EkatqZVj4mP2W4CwJR0adgrEobo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/*.py" ];

  pythonImportsCheck = [ "phonenumbers" ];

  meta = {
    description = "Python module for handling international phone numbers";
    homepage = "https://github.com/daviddrysdale/python-phonenumbers";
    changelog = "https://github.com/daviddrysdale/python-phonenumbers/blob/v${version}/python/HISTORY.md";
    license = lib.licenses.asl20;
  };
}
