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
  version = "0.10.1-beta.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "py-evm";
    tag = "v${version}";
    hash = "sha256-2BWMen/6ZcL1/SgGP0XcrTC63+LEjZO7Ogb3anhavsE=";
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
    py-ecc
    rlp
    trie
  ];

  nativeCheckInputs = [
    factory-boy
    hypothesis
    pytestCheckHook
    pytest-xdist
  ] ++ eth-hash.optional-dependencies.pycryptodome;

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
    description = "A Python implementation of the Ethereum Virtual Machine.";
    homepage = "https://github.com/ethereum/py-evm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hellwolf ];
  };
}
