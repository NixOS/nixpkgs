{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # dependencies
  eth-abi,
  eth-account,
  eth-keys,
  eth-utils,
  pydantic,
  rlp,
  semantic-version,
  # nativeCheckInputs
  py-evm,
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "eth-tester";
  version = "0.12.0-beta.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-tester";
    tag = "v${version}";
    hash = "sha256-ox7adsqD0MPZFcxBhino8cgwYYEWrBnD+ugPQOuOO2U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    eth-abi
    eth-account
    eth-keys
    eth-utils
    pydantic
    rlp
    semantic-version
  ];

  nativeCheckInputs = [
    py-evm
    pytestCheckHook
    pytest-xdist
  ];

  pythonImportsCheck = [ "eth_tester" ];

  meta = {
    description = "Tool suite for testing ethereum applications";
    homepage = "https://github.com/ethereum/eth-tester";
    changelog = "https://github.com/ethereum/eth-tester/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hellwolf ];
  };
}
