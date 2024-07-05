{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "eth-typing";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-typing";
    rev = "refs/tags/v${version}";
    hash = "sha256-JT/2bCPYFSRNt3V7QnHSAJR7HrZ1JpRKdU7gQpoYIn0=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "eth_typing" ];

  meta = with lib; {
    description = "Common type annotations for Ethereum Python packages";
    homepage = "https://github.com/ethereum/eth-typing";
    changelog = "https://github.com/ethereum/eth-typing/blob/v${version}/docs/release_notes.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
