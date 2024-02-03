{ lib
, stdenv
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
  version = "0.40.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "M2Crypto";
    inherit version;
    hash = "sha256-u/0RPsVXCMBYFiUqTwnkI33087v8gXHLvDMFfSV7uzA=";
  };

  nativeBuildInputs = [
    swig2
    openssl
  ];

  buildInputs = [
    openssl
    parameterized
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin (toString [
    "-Wno-error=implicit-function-declaration"
    "-Wno-error=incompatible-pointer-types"
  ]);

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
