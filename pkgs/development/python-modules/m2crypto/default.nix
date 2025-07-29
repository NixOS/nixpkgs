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
  version = "0.45.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/8ENTQmQFRT0CNx09gpNffIcROvJv3dslHv9xzWUIc8=";
  };
  patches = [
    (fetchurl {
      url = "https://sources.debian.org/data/main/m/m2crypto/0.42.0-2.1/debian/patches/0004-swig-Workaround-for-reading-sys-select.h-ending-with.patch";
      hash = "sha256-/Bkuqu/Od+S56AUWo0ZzpZF7FGMxP766K2GJnfKXrOI=";
    })
  ];

  build-system = [ setuptools ];

  nativeBuildInputs = [ swig ];

  buildInputs = [ openssl ];

  env = {
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
