{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.12.33";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de3d5a3cb421c7421f584bb13cb9287e23ee2dd97d832fc35c9b55b96a576a3c";
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
