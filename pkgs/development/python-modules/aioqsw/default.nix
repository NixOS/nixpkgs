{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
, setuptools
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "aioqsw";
<<<<<<< HEAD
  version = "0.3.4";
  format = "pyproject";

  disabled = pythonOlder "3.11";
=======
  version = "0.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-YGVQsw7UhRWXtfn2MQa3GHNlgXR4LJlFnaeLCGjmWfQ=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

=======
    hash = "sha256-Z7Q9b+ameddvGu9KJUNsaqOHiu0qXnpzuiZwg+/0+64=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aioqsw"
  ];

  meta = with lib; {
    description = "Library to fetch data from QNAP QSW switches";
    homepage = "https://github.com/Noltari/aioqsw";
    changelog = "https://github.com/Noltari/aioqsw/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
