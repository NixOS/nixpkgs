{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  eth-hash,
  eth-typing,
  eth-utils,
  hypothesis,
  parsimonious,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "eth-abi";
  version = "4.1.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-abi";
    rev = "v${version}";
    hash = "sha256-CGAfu3Ovz2WPJOD+4W2+cOAz+wYvuIyFL333Jw66ozA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "parsimonious>=0.9.0,<0.10.0" "parsimonious"
  '';

  propagatedBuildInputs = [
    eth-typing
    eth-utils
    parsimonious
  ];

  # lots of: TypeError: isinstance() arg 2 must be a type or tuple of types
  doCheck = false;

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ] ++ eth-hash.optional-dependencies.pycryptodome;

  disabledTests = [
    # boolean list representation changed
    "test_get_abi_strategy_returns_certain_strategies_for_known_type_strings"
    # hypothesis.errors.Flaky
    "test_base_equals_has_expected_behavior_for_parsable_types"
    "test_has_arrlist_has_expected_behavior_for_parsable_types"
    "test_is_base_tuple_has_expected_behavior_for_parsable_types"
  ];

  pythonImportsCheck = [ "eth_abi" ];

  meta = with lib; {
    description = "Ethereum ABI utilities";
    homepage = "https://github.com/ethereum/eth-abi";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
