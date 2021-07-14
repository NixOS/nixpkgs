{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.12.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Zbq269vg7FGWx0YmlJdI21M30jiVqrwe+PXXKEeHmYo=";
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
