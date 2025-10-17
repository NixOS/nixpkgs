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
  version = "5.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-utils";
    tag = "v${version}";
    hash = "sha256-uyUsX9jX2KumrERrIc6nXloH0G+rQeKzFMwex+Mh3eM=";
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

  meta = with lib; {
    changelog = "https://github.com/ethereum/eth-utils/blob/${src.rev}/docs/release_notes.rst";
    description = "Common utility functions for codebases which interact with ethereum";
    homepage = "https://github.com/ethereum/eth-utils";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
