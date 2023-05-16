{ lib
, fetchFromGitHub
, buildPythonPackage
, eth-hash
, eth-typing
, cytoolz
, hypothesis
, isPyPy
, pytestCheckHook
, pythonOlder
, toolz
}:

buildPythonPackage rec {
  pname = "eth-utils";
<<<<<<< HEAD
  version = "2.1.1";
=======
  version = "2.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Ogp4o99smw5qVwDec6zd/xVqqKMyNk41iBfRNzrwuvE=";
=======
    hash = "sha256-E2vUROc2FcAv00k50YpdxaaYIRDk1yGSPB8cHHw+7Yw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    eth-hash
    eth-typing
  ] ++ lib.optional (!isPyPy) cytoolz
  ++ lib.optional isPyPy toolz;

<<<<<<< HEAD
=======

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ] ++ eth-hash.optional-dependencies.pycryptodome;

<<<<<<< HEAD
  # Removing a poorly written test case from test suite.
  # TODO work with the upstream
  disabledTestPaths = [
    "tests/functional-utils/test_type_inference.py"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [ "eth_utils" ];

  meta = {
    description = "Common utility functions for codebases which interact with ethereum";
    homepage = "https://github.com/ethereum/eth-utils";
    license = lib.licenses.mit;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ ];
=======
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
