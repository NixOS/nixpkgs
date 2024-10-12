{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  openssl,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  swig,
}:

buildPythonPackage rec {
  pname = "m2crypto";
  version = "0.41.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "M2Crypto";
    inherit version;
    hash = "sha256-OhNYx+6EkEbZF4Knd/F4a/AnocHVG1+vjxlDW/w/FJU=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ swig ];

  buildInputs = [ openssl ];

  env =
    {
      NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin (toString [
        "-Wno-error=implicit-function-declaration"
        "-Wno-error=incompatible-pointer-types"
      ]);
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
