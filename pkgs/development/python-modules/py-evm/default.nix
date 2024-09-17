{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  cached-property,
  ckzg,
  eth-bloom,
  eth-hash,
  eth-keys,
  eth-typing,
  eth-utils,
  factory-boy,
  hypothesis,
  lru-dict,
  pydantic,
  pytestCheckHook,
  pytest-xdist,
  py-ecc,
  rlp,
  trie,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-evm";
  version = "0.10.1-beta.2";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "py-evm";
    rev = "refs/tags/v${version}";
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

  # side-effect: runs pip online check and is blocked by sandbox
  disabledTests = [ "test_install_local_wheel" ];

  # json-fixtures require fixture submodule and execution spec
  disabledTestPaths = [ "tests/json-fixtures" ];

  pythonImportsCheck = [ "eth" ];

  meta = {
    description = "A Python implementation of the Ethereum Virtual Machine.";
    homepage = "https://github.com/ethereum/py-evm";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.FlorianFranzen ];
  };
}
