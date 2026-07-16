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
  version = "0.13.0-beta.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-tester";
    tag = "v${version}";
    hash = "sha256-ssPtsEQAyaJde/empEpGU1bf3s4yxwlEXqpacN5GWDw=";
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

  disabledTests = [
    "test_install_local_wheel"
  ];

  meta = {
    description = "Tool suite for testing ethereum applications";
    homepage = "https://github.com/ethereum/eth-tester";
    changelog = "https://github.com/ethereum/eth-tester/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hellwolf ];
  };
}
