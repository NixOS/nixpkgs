{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # dependencies
  typing-extensions,
  # nativeCheckInputs
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "eth-typing";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-typing";
    tag = "v${version}";
    hash = "sha256-bdZrrglsJGNsqD6ShsqPO6ljViZr9Ms9A8Km45pnEYA=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  pythonImportsCheck = [ "eth_typing" ];

  disabledTests = [
    # side-effect: runs pip online check and is blocked by sandbox
    "test_install_local_wheel"
  ];

  meta = {
    description = "Common type annotations for Ethereum Python packages";
    homepage = "https://github.com/ethereum/eth-typing";
    changelog = "https://github.com/ethereum/eth-typing/blob/v${version}/docs/release_notes.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
  };
}
