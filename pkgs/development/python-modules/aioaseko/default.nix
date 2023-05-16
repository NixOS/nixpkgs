{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
<<<<<<< HEAD
, pyjwt
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "aioaseko";
<<<<<<< HEAD
  version = "0.1.1";
=======
  version = "0.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "milanmeu";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-bjPl0yrRaTIEEuPV8NbWu2hx/es5bcu2tDBZV+95fUc=";
=======
    rev = "v${version}";
    hash = "sha256-nJRVNBYfBcLYnBsTpQZYMHYWh0+hQObVKJ7sOXFwDjc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
<<<<<<< HEAD
    pyjwt
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aioaseko"
  ];

  meta = with lib; {
    description = "Module to interact with the Aseko Pool Live API";
    homepage = "https://github.com/milanmeu/aioaseko";
<<<<<<< HEAD
    changelog = "https://github.com/milanmeu/aioaseko/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
