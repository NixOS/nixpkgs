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
  version = "2.1.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "PyJWT";
    inherit version;
    sha256 = "sha256-+6ROeJi7yhYKKytQH0koJPyDgkhdOm8Rul0MGTfOYTA=";
  };

  propagatedBuildInputs = [
    cryptography
    ecdsa
  ];

  checkInputs = [
    pytest-cov
    pytestCheckHook
  ];

  disabledTests = lib.optionals (lib.versionOlder version "2.0") [
    # ecdsa changed internal behavior, required if one does 1.7.1 overriding
    "ec_verify_should_return_false_if_signature_invalid"
  ];

  pythonImportsCheck = [ "jwt" ];

  meta = with lib; {
    description = "JSON Web Token implementation in Python";
    homepage = "https://github.com/jpadilla/pyjwt";
    license = licenses.mit;
    maintainers = with maintainers; [ prikhi ];
  };
}
