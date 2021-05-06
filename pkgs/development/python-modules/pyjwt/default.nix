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
  pname = "PyJWT";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5c70a06e1f33d81ef25eecd50d50bd30e34de1ca8b2b9fa3fe0daaabcf69bf7";
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
