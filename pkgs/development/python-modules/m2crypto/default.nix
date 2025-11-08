{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  fetchurl,
  openssl,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  swig,
}:

buildPythonPackage rec {
  pname = "m2crypto";
  version = "0.45.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0PyBqIKO2/QwhDKzBAvwa7JrrZWruefUaQthGFUeduw=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ swig ];

  buildInputs = [ openssl ];

  env = {
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin (toString [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=incompatible-pointer-types"
    ]);
    OPENSSL_PATH = lib.optionalString stdenv.hostPlatform.isDarwin "${openssl.dev}";
  }
  // lib.optionalAttrs (stdenv.hostPlatform != stdenv.buildPlatform) {
    CPP = "${stdenv.cc.targetPrefix}cpp";
  };

  nativeCheckInputs = [
    pytestCheckHook
    openssl
  ];

  pythonImportsCheck = [ "M2Crypto" ];

  meta = with lib; {
    description = "Python crypto and SSL toolkit";
    homepage = "https://gitlab.com/m2crypto/m2crypto";
    changelog = "https://gitlab.com/m2crypto/m2crypto/-/blob/${version}/CHANGES";
    license = licenses.mit;
    maintainers = [ ];
  };
}
