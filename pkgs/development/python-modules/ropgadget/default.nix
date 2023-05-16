{ lib
, buildPythonPackage
, fetchFromGitHub
, capstone
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ropgadget";
<<<<<<< HEAD
  version = "7.4";
=======
  version = "7.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JonathanSalwan";
    repo = "ROPgadget";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-6m8opcTM4vrK+VCPXxNhZttUq6YmS8swLUDhjyfinWE=";
=======
    hash = "sha256-JvGDnMh42CbdsbE8jM3jD/4JMl6XlmkJfojvlBhFWA0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    capstone
  ];

  # Test suite is working with binaries
  doCheck = false;

  pythonImportsCheck = [
    "ropgadget"
  ];

  meta = with lib; {
    description = "Tool to search for gadgets in binaries to facilitate ROP exploitation";
    homepage = "http://shell-storm.org/project/ROPgadget/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bennofs ];
  };
}
