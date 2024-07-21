{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  karton-core,
  unittestCheckHook,
  pythonOlder,
  yara-python,
}:

buildPythonPackage rec {
  pname = "karton-yaramatcher";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-URGW8FyJZ3ktrwolls5ElSWn8FD6vWCA+Eu0aGtPh6U=";
  };

  propagatedBuildInputs = [
    karton-core
    yara-python
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "karton.yaramatcher" ];

  meta = with lib; {
    description = "File and analysis artifacts yara matcher for the Karton framework";
    mainProgram = "karton-yaramatcher";
    homepage = "https://github.com/CERT-Polska/karton-yaramatcher";
    changelog = "https://github.com/CERT-Polska/karton-yaramatcher/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
