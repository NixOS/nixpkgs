{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  fetchurl,
  openssl,
  pytestCheckHook,
  setuptools,
  swig,
}:

buildPythonPackage rec {
  pname = "m2crypto";
  version = "0.46.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E8L6iVYve4r0DMdLVfSQvl4quMz7c58RwW085iIaYbo=";
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
