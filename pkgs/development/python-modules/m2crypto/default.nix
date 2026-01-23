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
  version = "0.46.2";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "m2crypto";
    repo = "m2crypto";
    tag = finalAttrs.version;
    hash = "sha256-XV9aILSWfQ/xKDySflG3wiNRP4YVPVujuhIz2VdPuBc=";
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
    changelog = "https://gitlab.com/m2crypto/m2crypto/-/tags/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
