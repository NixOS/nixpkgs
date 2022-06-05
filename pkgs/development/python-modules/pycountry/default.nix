{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pycountry";
  version = "22.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-shY6JGxYWJTYCPGHg+GRN8twoMGPs2dI3AH8bxCcFkY=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pycountry"
  ];

  meta = with lib; {
    homepage = "https://github.com/flyingcircusio/pycountry";
    description = "ISO country, subdivision, language, currency and script definitions and their translations";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ];
  };

}
