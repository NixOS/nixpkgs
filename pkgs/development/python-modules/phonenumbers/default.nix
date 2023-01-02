{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.13.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AXn2iNSMDn4WHre52G1YeUCvH1F0+Xwf39iTxZnA2Uo=";
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
