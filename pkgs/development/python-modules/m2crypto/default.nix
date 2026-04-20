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
  version = "0.48.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    inherit pname version;
    owner = "m2crypto";
    repo = "m2crypto";
    tag = version;
    hash = "sha256-Ya1og1x3EPbHkrY74tkdkMOJreS3x8x/1oVfwcpAEOU=";
  };

  # https://lists.sr.ht/~mcepl/m2crypto/%3CCAPhw1+Hg6+OJZoqt1O6aezxnTUFmfFTMzDwkD2bJ74jnmygqrg@mail.gmail.com%3E
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/SWIG/_lib.h \
      --replace-fail "|| defined(__clang__)" "&& !defined(__clang__)"
    substituteInPlace src/SWIG/_m2crypto.i \
      --replace-fail "PRAGMA_IGNORE_UNUSED_LABEL" "" \
      --replace-fail "PRAGMA_WARN_STRICT_PROTOTYPES" ""
  '';

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
    changelog = "https://gitlab.com/m2crypto/m2crypto/-/tags/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
