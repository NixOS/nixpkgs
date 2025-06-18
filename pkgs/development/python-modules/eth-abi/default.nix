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
}:

buildPythonPackage rec {
  pname = "eth-abi";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-abi";
    tag = "v${version}";
    hash = "sha256-D3aGMx2oZFttwQ90ouwQbbRelCb2bvyQgvamKweX9Nw=";
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
  ] ++ eth-hash.optional-dependencies.pycryptodome;

  disabledTests = [
    # boolean list representation changed
    "test_get_abi_strategy_returns_certain_strategies_for_known_type_strings"
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
