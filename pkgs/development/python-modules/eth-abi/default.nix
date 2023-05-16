{ lib
, buildPythonPackage
, fetchFromGitHub
, eth-hash
, eth-typing
, eth-utils
, hypothesis
, parsimonious
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "eth-abi";
<<<<<<< HEAD
  version = "4.1.0";
=======
  version = "3.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-abi";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-CGAfu3Ovz2WPJOD+4W2+cOAz+wYvuIyFL333Jw66ozA=";
=======
    hash = "sha256-xrZpT/9zwDtjSwSPDDse+Aq8plPm26OR/cIrliZUpLY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace setup.py \
<<<<<<< HEAD
      --replace "parsimonious>=0.9.0,<0.10.0" "parsimonious"
=======
      --replace "parsimonious>=0.8.0,<0.9.0" "parsimonious"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
