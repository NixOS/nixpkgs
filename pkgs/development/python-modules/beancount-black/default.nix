{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, beancount-parser
, click
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "beancount-black";
<<<<<<< HEAD
  version = "0.2.1";
=======
  version = "0.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beancount-black";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-wvAQnwnyHn5Koc/UN4zpJ3JDmFbDoUrpCTmJCpSP7Mg=";
=======
    hash = "sha256-1n+IADiGUsi69XoxO4Tjio2QdkJyoYZHgvYc646TuF4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    beancount-parser
    click
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "beancount_black"
  ];

  meta = with lib; {
    description = "Opinioned code formatter for Beancount";
    homepage = "https://github.com/LaunchPlatform/beancount-black/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ambroisie ];
  };
}
