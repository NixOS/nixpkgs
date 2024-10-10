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
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-keyring-linux";
    rev = "refs/tags/v${version}";
    hash = "sha256-feIgRC0U7d96gFcmHqRF3/8k/bsxlPJs1/K+ki7uXys=";
  };

  build-system = [ setuptools ];

  dependencies = [
    keyring
    proton-core
  ];

  pythonImportsCheck = [ "proton.keyring_linux.core" ];

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
