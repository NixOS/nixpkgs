{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  eth-hash,
  eth-typing,
  cytoolz,
  hypothesis,
  isPyPy,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  toolz,
}:

buildPythonPackage rec {
  pname = "eth-utils";
  version = "4.0.0";
  pyproject = true;
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-utils";
    rev = "v${version}";
    hash = "sha256-k2pHM1eKPzoGxZlU6yT7bZMv4CCWGaZaSnFHSbT76Zo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    eth-hash
    eth-typing
  ] ++ lib.optional (!isPyPy) cytoolz ++ lib.optional isPyPy toolz;

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ] ++ eth-hash.optional-dependencies.pycryptodome;

  # Removing a poorly written test case from test suite.
  # TODO work with the upstream
  disabledTestPaths = [ "tests/functional-utils/test_type_inference.py" ];

  pythonImportsCheck = [ "eth_utils" ];

  meta = {
    changelog = "https://github.com/ethereum/eth-utils/blob/${src.rev}/docs/release_notes.rst";
    description = "Common utility functions for codebases which interact with ethereum";
    homepage = "https://github.com/ethereum/eth-utils";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
