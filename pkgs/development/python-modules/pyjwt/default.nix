{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, ecdsa
, pytest-cov
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyjwt";
  version = "2.3.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "PyJWT";
    inherit version;
    sha256 = "sha256-uIi01W8G9tzXdyEMM05pxze+dHVdPl6e4/5n3Big7kE=";
  };

  propagatedBuildInputs = [
    cryptography
    ecdsa
  ];

  checkInputs = [
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jwt" ];

  meta = with lib; {
    description = "JSON Web Token implementation in Python";
    homepage = "https://github.com/jpadilla/pyjwt";
    license = licenses.mit;
    maintainers = with maintainers; [ prikhi ];
  };
}
