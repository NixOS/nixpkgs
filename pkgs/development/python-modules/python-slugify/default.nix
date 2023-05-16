{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, text-unidecode
, unidecode
}:

buildPythonPackage rec {
  pname = "python-slugify";
<<<<<<< HEAD
  version = "8.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "6.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "un33k";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-MJac63XjgWdUQdyyEm8O7gAGVszmHxZzRF4frJtR0BU=";
=======
    rev = "v${version}";
    hash = "sha256-JGjUNBEMuICsaClQGDSGX4qFRjecVKzmpPNRUTvfwho=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    text-unidecode
<<<<<<< HEAD
  ];

  passthru.optional-dependencies = {
    unidecode = [
      unidecode
    ];
  };

=======
    unidecode
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test.py"
  ];

  pythonImportsCheck = [
    "slugify"
  ];

  meta = with lib; {
    description = "Python Slugify application that handles Unicode";
    homepage = "https://github.com/un33k/python-slugify";
<<<<<<< HEAD
    changelog = "https://github.com/un33k/python-slugify/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ vrthra ];
  };
}
