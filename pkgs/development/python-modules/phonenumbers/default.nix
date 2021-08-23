{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.12.30";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ca65c36f437881a8f7dac979a5733ae8fb5a0a436aecd47bd2c06494bdf0a20";
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
