{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  bitarray,
  ckzg,
  eth-abi,
  eth-keyfile,
  eth-keys,
  eth-rlp,
  eth-utils,
  hexbytes,
  rlp,
  websockets,

  # tests
  hypothesis,
  pydantic,
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "eth-account";
  version = "0.13.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-account";
    tag = "v${version}";
    hash = "sha256-CBD0vJLYA+3FreOTsVXJlDJhRvPbDUn4X55o6EF+uBA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bitarray
    ckzg
    eth-abi
    eth-keyfile
    eth-keys
    eth-rlp
    eth-utils
    hexbytes
    rlp
    websockets
  ];

  nativeCheckInputs = [
    hypothesis
    pydantic
    pytestCheckHook
    pytest-xdist
  ];

  disabledTests = [
    # requires local nodejs install
    "test_messages_where_all_3_sigs_match"
    "test_messages_where_eth_account_matches_ethers_but_not_metamask"
    "test_messages_where_eth_account_matches_metamask_but_not_ethers"

    # disable flaky fuzzing test
    "test_compatibility"

    # Attempts at installing the wheel
    "test_install_local_wheel"
  ];

  pythonImportsCheck = [ "eth_account" ];

  meta = {
    description = "Account abstraction library for web3.py";
    homepage = "https://github.com/ethereum/eth-account";
    changelog = "https://github.com/ethereum/eth-account/blob/v${version}/docs/release_notes.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hellwolf ];
  };
}
