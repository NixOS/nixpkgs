{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,
  openssl,
  pytestCheckHook,
  setuptools,
  swig,
}:

buildPythonPackage (finalAttrs: {
  pname = "m2crypto";
  version = "0.45.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "m2crypto";
    repo = "m2crypto";
    tag = finalAttrs.version;
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
    changelog = "https://gitlab.com/m2crypto/m2crypto/-/blob/${finalAttrs.version}/CHANGES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
