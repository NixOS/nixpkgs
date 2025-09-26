{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # dependencies
  eth-keys,
  eth-utils,
  pycryptodome,
  py-ecc,
  # nativeCheckInputs
  pytestCheckHook,
  pydantic,
}:

buildPythonPackage rec {
  pname = "eth-keyfile";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-keyfile";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-DR17EupRDnviN6OXF+B+RlCVdG8cfcvnIgIEKxrXFKs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    eth-keys
    eth-utils
    pycryptodome
    py-ecc
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pydantic
  ];

  pythonImportsCheck = [ "eth_keyfile" ];

  disabledTests = [
    "test_install_local_wheel"
  ];

  meta = {
    description = "Tools for handling the encrypted keyfile format used to store private keys";
    homepage = "https://github.com/ethereum/eth-keyfile";
    changelog = "https://github.com/ethereum/eth-keyfile/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hellwolf ];
  };
}
