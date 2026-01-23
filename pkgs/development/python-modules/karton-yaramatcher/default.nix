{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  karton-core,
  unittestCheckHook,
  yara-python,
}:

buildPythonPackage rec {
  pname = "karton-yaramatcher";
  version = "1.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton-yaramatcher";
    tag = "v${version}";
    hash = "sha256-URGW8FyJZ3ktrwolls5ElSWn8FD6vWCA+Eu0aGtPh6U=";
  };

  propagatedBuildInputs = [
    karton-core
    yara-python
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "karton.yaramatcher" ];

  meta = {
    description = "File and analysis artifacts yara matcher for the Karton framework";
    mainProgram = "karton-yaramatcher";
    homepage = "https://github.com/CERT-Polska/karton-yaramatcher";
    changelog = "https://github.com/CERT-Polska/karton-yaramatcher/releases/tag/v${version}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
