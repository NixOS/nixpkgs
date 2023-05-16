{ lib
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "iso3166";
<<<<<<< HEAD
  version = "2.1.1";
=======
  version = "2.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "deactivated";
    repo = "python-iso3166";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
=======
    rev = version;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    hash = "sha256-/y7c2qSA6+WKUP9YTSaMBjBxtqAuF4nB3MKvL5P6vL0=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "iso3166"
  ];

  meta = with lib; {
    description = "Self-contained ISO 3166-1 country definitions";
    homepage = "https://github.com/deactivated/python-iso3166";
<<<<<<< HEAD
    changelog = "https://github.com/deactivated/python-iso3166/blob/v${version}/CHANGES";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ zraexy ];
  };
}
