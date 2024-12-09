{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  pytestCheckHook,
  typing-extensions,
  setuptools,
}:

buildPythonPackage rec {
  pname = "eth-typing";
  version = "5.0.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-typing";
    rev = "refs/tags/v${version}";
    hash = "sha256-WFTx5u85Gp+jQPWS3BTk1Pky07C2fVAzwrG/c3hSRzM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  dependencies = [ typing-extensions ];

  pythonImportsCheck = [ "eth_typing" ];

  meta = with lib; {
    description = "Common type annotations for Ethereum Python packages";
    homepage = "https://github.com/ethereum/eth-typing";
    changelog = "https://github.com/ethereum/eth-typing/blob/v${version}/docs/release_notes.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
