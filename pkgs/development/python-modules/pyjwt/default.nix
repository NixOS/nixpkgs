{ lib, buildPythonPackage, fetchPypi
, cryptography, ecdsa
, pytestrunner, pytestcov, pytest }:

buildPythonPackage rec {
  pname = "PyJWT";
  version = "1.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ee413b357d53fd3fb44704577afac88e72e878716116270d722723d65b42176";
  };

  propagatedBuildInputs = [ cryptography ecdsa ];

  checkInputs = [ pytestrunner pytestcov pytest ];

  meta = with lib; {
    description = "JSON Web Token implementation in Python";
    homepage = https://github.com/jpadilla/pyjwt;
    license = licenses.mit;
    maintainers = with maintainers; [ prikhi ];
  };
}
