{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.13.53";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tzCPIYN976VntPlhkltsZS3VFI8+D629FYoQdYzGPZE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/*.py" ];

  pythonImportsCheck = [ "phonenumbers" ];

  meta = with lib; {
    description = "Python module for handling international phone numbers";
    homepage = "https://github.com/daviddrysdale/python-phonenumbers";
    changelog = "https://github.com/daviddrysdale/python-phonenumbers/blob/v${version}/python/HISTORY.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fadenb ];
  };
}
