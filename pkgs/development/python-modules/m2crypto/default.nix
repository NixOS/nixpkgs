{ lib
, buildPythonPackage
, fetchPypi
, openssl
, parameterized
, pytestCheckHook
, pythonOlder
, swig2
}:

buildPythonPackage rec {
  pname = "m2crypto";
  version = "0.39.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "M2Crypto";
    inherit version;
    hash = "sha256-JMD0cTWLixmtTIqp2hLoaAMLZcH9syedAG32DJUBM4o=";
  };

  nativeBuildInputs = [
    swig2
    openssl
  ];

  buildInputs = [
    openssl
    parameterized
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "M2Crypto"
  ];

  meta = with lib; {
    description = "A Python crypto and SSL toolkit";
    homepage = "https://gitlab.com/m2crypto/m2crypto";
    changelog = "https://gitlab.com/m2crypto/m2crypto/-/blob/${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
