{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  bitarray,
  ckzg,
  eth-abi,
  eth-keyfile,
  eth-keys,
  eth-rlp,
  eth-utils,
  websockets,
  hexbytes,
  hypothesis,
  pydantic,
  pytestCheckHook,
  pytest-xdist,
  rlp,
  setuptools,
}:

buildPythonPackage rec {
  pname = "eth-account";
  version = "0.13.3";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-account";
    rev = "refs/tags/v${version}";
    hash = "sha256-657l7M7euUGXXKTrQyB/kVA4miyePr310enhkaSBJss=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
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
  ];

  pythonImportsCheck = [ "eth_account" ];

  meta = {
    changelog = "https://github.com/ethereum/eth-account/blob/v${version}/docs/release_notes.rst";
    description = "Account abstraction library for web3.py";
    homepage = "https://github.com/ethereum/eth-account";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.FlorianFranzen ];
  };
}
