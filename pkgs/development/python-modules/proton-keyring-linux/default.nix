{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  keyring,
  proton-core,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "proton-keyring-linux";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-keyring-linux";
    tag = "v${version}";
    hash = "sha256-wT+0S3dGanLwqRrpCooAwy/RDyZDn1aEdJ7eWvwVfiY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    keyring
    proton-core
  ];

  pythonImportsCheck = [
    "proton.keyring_linux.core"
    "proton.keyring_linux"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = {
    description = "ProtonVPN core component to access Linux's keyring";
    homepage = "https://github.com/ProtonVPN/python-proton-keyring-linux";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
