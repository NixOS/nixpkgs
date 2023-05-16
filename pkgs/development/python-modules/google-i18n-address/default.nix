{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, hatchling
, requests
, pytestCheckHook
, pythonOlder
=======
, requests
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "google-i18n-address";
<<<<<<< HEAD
  version = "3.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";
=======
  version = "2.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mirumee";
    repo = "google-i18n-address";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-dW/1wwnFDjYpym1ZaSZ7mOLpkHxsvuAHC8zBRekxWaw=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "i18naddress"
  ];
=======
    hash = "sha256-7t5sNpEVajdwcW8+xTNZQKZVgxhUzfbVbEVgn7JJ2MY=";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "i18naddress" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Google's i18n address data packaged for Python";
    homepage = "https://github.com/mirumee/google-i18n-address";
<<<<<<< HEAD
    changelog = "https://github.com/mirumee/google-i18n-address/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
    license = licenses.bsd3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
