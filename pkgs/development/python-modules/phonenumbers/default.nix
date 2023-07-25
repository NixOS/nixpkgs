{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.13.16";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kncrFC6snzrrDoeVjENplqwW1GjZZkZIOZfIpXUXkzs=";
  };

  nativeCheckInputs = [
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
    changelog = "https://github.com/daviddrysdale/python-phonenumbers/blob/v${version}/python/HISTORY.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fadenb ];
  };
}
