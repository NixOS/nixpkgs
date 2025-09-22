{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # dependencies
  eth-typing,
  eth-utils,
  parsimonious,
  # nativeCheckInputs
  hypothesis,
  pytestCheckHook,
  pytest-xdist,
  eth-hash,
  pydantic,
}:

buildPythonPackage rec {
  pname = "eth-abi";
  version = "5.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-abi";
    tag = "v${version}";
    hash = "sha256-/tyGm/lH72oZEKfTd25t+k0y3TuAZQg+hUABT4YCP2g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    eth-typing
    eth-utils
    parsimonious
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-xdist
    pydantic
  ]
  ++ eth-hash.optional-dependencies.pycryptodome;

  disabledTests = [
    # boolean list representation changed
    "test_get_abi_strategy_returns_certain_strategies_for_known_type_strings"
    "test_install_local_wheel"
  ];

  pythonImportsCheck = [ "eth_abi" ];

  meta = {
    description = "Ethereum ABI utilities";
    homepage = "https://github.com/ethereum/eth-abi";
    changelog = "https://github.com/ethereum/eth-abi/blob/v${version}/docs/release_notes.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hellwolf ];
  };
}
