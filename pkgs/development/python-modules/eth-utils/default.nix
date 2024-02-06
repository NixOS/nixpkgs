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
  version = "2.1.1";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ogp4o99smw5qVwDec6zd/xVqqKMyNk41iBfRNzrwuvE=";
  };

  propagatedBuildInputs = [
    eth-hash
    eth-typing
  ] ++ lib.optional (!isPyPy) cytoolz
  ++ lib.optional isPyPy toolz;

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ] ++ eth-hash.optional-dependencies.pycryptodome;

  # Removing a poorly written test case from test suite.
  # TODO work with the upstream
  disabledTestPaths = [
    "tests/functional-utils/test_type_inference.py"
  ];

  pythonImportsCheck = [ "eth_utils" ];

  meta = {
    description = "Common utility functions for codebases which interact with ethereum";
    homepage = "https://github.com/ethereum/eth-utils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
