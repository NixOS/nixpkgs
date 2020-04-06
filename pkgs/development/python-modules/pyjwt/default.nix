{ lib, buildPythonPackage, fetchPypi
, cryptography, ecdsa
, pytestrunner, pytestcov, pytest }:

buildPythonPackage rec {
  pname = "PyJWT";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d59a976fb773f3e6a39c85636357c4f0e242707394cadadd9814f5cbaa20e96";
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
    homepage = https://github.com/jpadilla/pyjwt;
    license = licenses.mit;
    maintainers = with maintainers; [ prikhi ];
  };
}
