{ lib, buildPythonPackage, fetchPypi
, cryptography, ecdsa
, pytestrunner, pytestcov, pytest }:

buildPythonPackage rec {
  pname = "PyJWT";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5c70a06e1f33d81ef25eecd50d50bd30e34de1ca8b2b9fa3fe0daaabcf69bf7";
  };

  propagatedBuildInputs = [ cryptography ecdsa ];

  checkInputs = [ pytestrunner pytestcov pytest ];

  postPatch = ''
    substituteInPlace setup.py --replace "pytest>=4.0.1,<5.0.0" "pytest"
  '';

  # ecdsa changed internal behavior
  checkPhase = ''
    pytest tests -k 'not ec_verify_should_return_false_if_signature_invalid'
  '';

  meta = with lib; {
    description = "JSON Web Token implementation in Python";
    homepage = "https://github.com/jpadilla/pyjwt";
    license = licenses.mit;
    maintainers = with maintainers; [ prikhi ];
  };
}
