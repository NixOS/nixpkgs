{
  lib,
  olefile,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  cryptography,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "msoffcrypto-tool";
  version = "5.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nolze";
    repo = "msoffcrypto-tool";
    rev = "refs/tags/v${version}";
    hash = "sha256-BVm4hMKvvNI3bJ82t4NIRcx8o8mgQgoulIerDwoVIT0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    cryptography
    olefile
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Test fails with AssertionError
    "test_cli"
  ];

  pythonImportsCheck = [ "msoffcrypto" ];

  meta = with lib; {
    description = "Python tool and library for decrypting MS Office files with passwords or other keys";
    homepage = "https://github.com/nolze/msoffcrypto-tool";
    changelog = "https://github.com/nolze/msoffcrypto-tool/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "msoffcrypto-tool";
  };
}
