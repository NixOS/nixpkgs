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
  version = "8.13.46";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lL8Yupclu2ho0pRzsT947wHiWFxctWHsAgC+dnbndFI=";
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
