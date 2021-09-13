{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.12.32";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c52c9c3607483072303ba8d8759063edc44d2f8fe7b85afef40bd8d1aafb6483";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/*.py" ];

  pythonImportsCheck = [ "phonenumbers" ];

  meta = with lib; {
    description = "Python module for handling international phone numbers";
    homepage = "https://github.com/daviddrysdale/python-phonenumbers";
    license = licenses.asl20;
    maintainers = with maintainers; [ fadenb ];
  };
}
