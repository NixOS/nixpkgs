{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "aioairzone";
<<<<<<< HEAD
  version = "0.6.8";
  format = "pyproject";

  disabled = pythonOlder "3.11";
=======
  version = "0.5.5";
  format = "pyproject";

  disabled = pythonOlder "3.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-aCf0IO70t/QMmDmIwBKN3Um1HgHjHn1r6Dze/pWaQ5M=";
=======
    hash = "sha256-6PBNwCfh5ryR3Jub3GDykY6lRQt9wdkV8yWkvivuQpM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aioairzone"
  ];

  meta = with lib; {
    description = "Module to control AirZone devices";
    homepage = "https://github.com/Noltari/aioairzone";
    changelog = "https://github.com/Noltari/aioairzone/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}

