{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, unittestCheckHook
, pythonOlder
, yara-python
}:

buildPythonPackage rec {
  pname = "karton-yaramatcher";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-URGW8FyJZ3ktrwolls5ElSWn8FD6vWCA+Eu0aGtPh6U=";
=======
    hash = "sha256-ulWwPXbjqQXwSRi8MFdcx7vC7P19yu66Ll8jkuTesao=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    karton-core
    yara-python
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "karton.yaramatcher"
  ];

  meta = with lib; {
    description = "File and analysis artifacts yara matcher for the Karton framework";
    homepage = "https://github.com/CERT-Polska/karton-yaramatcher";
    changelog = "https://github.com/CERT-Polska/karton-yaramatcher/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
