{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cffi,
  srtp,
  openssl,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylibsrtp";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aiortc";
    repo = "pylibsrtp";
    tag = finalAttrs.version;
    hash = "sha256-Q8EyGAJKkq14sqSEMWLB8arKvj/wuALK/XwOZ27F1nQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cffi
    srtp
    openssl
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  doCheck = true;
  pythonImportsCheck = [
    "pylibsrtp"
  ];

  meta = {
    description = "Python bindings for libsrtp";
    homepage = "https://github.com/aiortc/pylibsrtp";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ gesperon ];
  };
})
