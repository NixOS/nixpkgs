{
  lib,
  buildPythonPackage,
  capstone,
  click,
  cryptography,
  dnfile,
  fetchFromGitHub,
  pefile,
  pycryptodomex,
  pyelftools,
  pythonOlder,
  setuptools,
  pytestCheckHook,
  typing-extensions,
  yara-python,
}:

buildPythonPackage rec {
  pname = "malduck";
  version = "4.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "malduck";
    rev = "refs/tags/v${version}";
    hash = "sha256-Btx0HxiZWrb0TDpBokQGtBE2EDK0htONe/DwqlPgAd4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    capstone
    click
    cryptography
    dnfile
    pefile
    pycryptodomex
    pyelftools
    typing-extensions
    yara-python
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "malduck" ];

  meta = with lib; {
    description = "Helper for malware analysis";
    homepage = "https://github.com/CERT-Polska/malduck";
    changelog = "https://github.com/CERT-Polska/malduck/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "malduck";
  };
}
