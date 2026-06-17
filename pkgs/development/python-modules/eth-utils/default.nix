{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  isPyPy,
  # dependencies
  eth-hash,
  eth-typing,
  cytoolz,
  toolz,
  pydantic,
  # nativeCheckInputs
  hypothesis,
  mypy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "eth-utils";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-utils";
    tag = "v${version}";
    hash = "sha256-U1RSKaLw/gDg4lMjkTwR/Wfb5wqQctML9CDZBILMBys=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    eth-hash
    eth-typing
  ]
  ++ lib.optional (!isPyPy) cytoolz
  ++ lib.optional isPyPy toolz;

  nativeCheckInputs = [
    hypothesis
    mypy
    pytestCheckHook
    pydantic
  ]
  ++ eth-hash.optional-dependencies.pycryptodome;

  pythonImportsCheck = [ "eth_utils" ];

  disabledTests = [ "test_install_local_wheel" ];

  meta = {
    changelog = "https://github.com/ethereum/eth-utils/blob/${src.rev}/docs/release_notes.rst";
    description = "Common utility functions for codebases which interact with ethereum";
    homepage = "https://github.com/ethereum/eth-utils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
  };
}
