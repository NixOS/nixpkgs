{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.12.55";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G+PHNT6TJd3qqQmrF5NkI8YpWNVwDWjl2lvpUDxG0Ic=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/*.py"
  ];

  pythonImportsCheck = [
    "phonenumbers"
  ];

  meta = with lib; {
    description = "Python module for handling international phone numbers";
    homepage = "https://github.com/daviddrysdale/python-phonenumbers";
    license = licenses.asl20;
    maintainers = with maintainers; [ fadenb ];
  };
}
