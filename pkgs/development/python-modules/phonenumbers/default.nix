{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.12.56";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gqTyJskw0C3N9tSynkz9hniZH+ZcLv1f3RQ1VxhvCGg=";
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
