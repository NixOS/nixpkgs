{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "oath";
  version = "1.4.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vWsg0g8sTj9TUj7pACEdynWu7KcvT1qf2NyswXX+HAs=";
  };
  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "oath"
  ];

  meta = with lib; {
    description = "Python implementation of the three main OATH specifications: HOTP, TOTP and OCRA";
    homepage = "https://github.com/bdauvergne/python-oath";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aw ];
  };
}
