{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  base58,
  cashaddress,
  pbkdf2,
  pyperclip,
  requests,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycryptotools";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Toporin";
    repo = "pybitcointools";
    tag = "v${version}";
    hash = "sha256-6INyD24OVcIYDiWK9/bHAIh9crpeJBDLeUqQ9+P24HM=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "requests"
  ];

  dependencies = [
    base58
    cashaddress
    pbkdf2
    pyperclip
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "test.py"
    "test_logging.py"
    "test_satodime.py"
  ];

  disabledTests = [
    # Requires network access to external block explorers
    "test_explorer"
  ];

  pythonImportsCheck = [
    "pycryptotools"
  ];

  meta = {
    description = "Python library for Crypto coins signatures and transactions";
    homepage = "https://github.com/Toporin/pybitcointools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eymeric ];
  };
}
