{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, lark
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "beancount-parser";
<<<<<<< HEAD
  version = "0.2.0";
=======
  version = "0.1.23";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beancount-parser";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-VSl+Jde/mDSUpICXjmPKID6qZiKUUaK8ixztP1qaoDM=";
=======
    hash = "sha256-3pO1HvH3R2RpNFtplWyaXxqZy0caAoAxlmfSKmjkvKQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    lark
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "beancount_parser"
  ];

  meta = with lib; {
    description = "Standalone Lark based Beancount syntax parser";
    homepage = "https://github.com/LaunchPlatform/beancount-parser/";
    changelog = "https://github.com/LaunchPlatform/beancount-parser/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ambroisie ];
  };
}
