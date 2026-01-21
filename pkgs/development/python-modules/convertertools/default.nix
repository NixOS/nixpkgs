{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  poetry-core,
  setuptools,

  # checks
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "convertertools";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "convertertools";
    tag = "v${version}";
    hash = "sha256-YLEZGTq3wtiLsqQkdxcdM4moUEYPN29Uai5o81FUtVc=";
  };

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "convertertools" ];

  meta = {
    description = "Tools for converting python data types";
    homepage = "https://github.com/bluetooth-devices/convertertools";
    changelog = "https://github.com/bluetooth-devices/convertertools/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
