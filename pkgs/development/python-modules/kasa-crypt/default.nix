{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  poetry-core,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "kasa-crypt";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "kasa-crypt";
    tag = "v${version}";
    hash = "sha256-rSRLrlV3QLatI2G8sd2jDwd6U8k4MrJil62ki1kNEMc=";
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

  pythonImportsCheck = [ "kasa_crypt" ];

  meta = with lib; {
    description = "Fast kasa crypt";
    homepage = "https://github.com/bdraco/kasa-crypt";
    changelog = "https://github.com/bdraco/kasa-crypt/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
