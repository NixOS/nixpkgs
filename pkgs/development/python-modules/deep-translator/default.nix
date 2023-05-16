{ lib
, buildPythonPackage
, fetchPypi
, beautifulsoup4
, requests
, click
, pythonOlder
<<<<<<< HEAD
, poetry-core
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "deep-translator";
<<<<<<< HEAD
  version = "1.11.4";
  format = "pyproject";
=======
  version = "1.10.1";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "deep_translator";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-gBJgxpIxE4cH6oiglV5ITbfUDiEMngrg93Ny/9pfS/U=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

=======
    hash = "sha256-6ZQ42rcOO+vNqTLj9ehv09MrQ/h9Zu2fi2gW2xRvHZ8=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    beautifulsoup4
    requests
    click
  ];

  # Initializing it during build won't work as it needs connection with
  # APIs and the build environment is isolated (#148572 for details).
  # After built, it works as intended.
  #pythonImportsCheck = [ "deep_translator" ];

  # Again, initializing an instance needs network connection.
  # Tests will fail.
  doCheck = false;

  meta = with lib; {
    description = "Python tool to translate between different languages by using multiple translators";
    homepage = "https://deep-translator.readthedocs.io";
<<<<<<< HEAD
    changelog = "https://github.com/nidhaloff/deep-translator/releases/tag/v${version}";
=======
    changelog = "https://github.com/nidhaloff/deep-translator/releases/tag/v1.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
