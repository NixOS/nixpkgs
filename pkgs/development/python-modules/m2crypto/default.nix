{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,
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

  src = fetchFromGitLab {
    inherit pname version;
    owner = "m2crypto";
    repo = "m2crypto";
    tag = version;
    hash = "sha256-jg7XcYE7oTOkePDJPXyM/X+vE8F2pIvJbwrVj6KJ3eM=";
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

  disabledTests = [
    # Connection refused
    "test_makefile_err"
  ];

  # Tests require localhost access
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "M2Crypto" ];

  meta = {
    description = "Python crypto and SSL toolkit";
    homepage = "https://gitlab.com/m2crypto/m2crypto";
    changelog = "https://gitlab.com/m2crypto/m2crypto/-/blob/${version}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
