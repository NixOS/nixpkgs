{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # dependencies
  eth-keys,
  eth-utils,
  pycryptodome,
  # nativeCheckInputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "eth-keyfile";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-keyfile";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-HufsN3aXdQErcQmnG2PZnEm5joqpy4f8IWNm3VrzJSY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    eth-keys
    eth-utils
    pycryptodome
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "eth_keyfile" ];

  meta = {
    description = "Tools for handling the encrypted keyfile format used to store private keys";
    homepage = "https://github.com/ethereum/eth-keyfile";
    changelog = "https://github.com/ethereum/eth-keyfile/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hellwolf ];
  };
}
