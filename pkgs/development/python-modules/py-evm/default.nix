{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # dependencies
  cached-property,
  ckzg,
  eth-bloom,
  eth-keys,
  eth-typing,
  eth-utils,
  lru-dict,
  pydantic,
  py-ecc,
  rlp,
  trie,
  # nativeCheckInputs
  factory-boy,
  hypothesis,
  pytestCheckHook,
  pytest-xdist,
  eth-hash,
}:

buildPythonPackage rec {
  pname = "py-evm";
  version = "0.12.1-beta.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "py-evm";
    tag = "v${version}";
    hash = "sha256-n2F0ApdmIED0wrGuNN45lyb7cGu8pRn8mLDehT7Ru9E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cached-property
    ckzg
    eth-bloom
    eth-keys
    eth-typing
    eth-utils
    lru-dict
    pydantic
    py-ecc
    rlp
    trie
  ];

  nativeCheckInputs = [
    factory-boy
    hypothesis
    pytestCheckHook
    pytest-xdist
  ]
  ++ eth-hash.optional-dependencies.pycryptodome;

  disabledTests = [
    # side-effect: runs pip online check and is blocked by sandbox
    "test_install_local_wheel"
  ];

  disabledTestPaths = [
    # json-fixtures require fixture submodule and execution spec
    "tests/json-fixtures"
  ];

  pythonImportsCheck = [ "eth" ];

  meta = {
    description = "Python implementation of the Ethereum Virtual Machine";
    homepage = "https://github.com/ethereum/py-evm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hellwolf ];
  };
}
