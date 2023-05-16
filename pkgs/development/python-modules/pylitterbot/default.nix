{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
<<<<<<< HEAD
, poetry-dynamic-versioning
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pyjwt
, pytest-aiohttp
, pytest-freezegun
, pytestCheckHook
, pythonOlder
, deepdiff
}:

buildPythonPackage rec {
  pname = "pylitterbot";
<<<<<<< HEAD
  version = "2023.4.8";
=======
  version = "2023.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "natekspencer";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-74EKgHocrEi37bh4WBoYyLKF1XYrwxT7e2oo3igTWms=";
=======
    rev = "refs/tags/${version}";
    hash = "sha256-nF6njY2qNoHW2ZGNDHNeTBTjSBbitJxitPgyayLaqSE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
<<<<<<< HEAD
    poetry-dynamic-versioning
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    aiohttp
    deepdiff
    pyjwt
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytest-freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pylitterbot"
  ];

  meta = with lib; {
    description = "Modulefor controlling a Litter-Robot";
    homepage = "https://github.com/natekspencer/pylitterbot";
<<<<<<< HEAD
    changelog = "https://github.com/natekspencer/pylitterbot/releases/tag/v${version}";
=======
    changelog = "https://github.com/natekspencer/pylitterbot/releases/tag/${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
