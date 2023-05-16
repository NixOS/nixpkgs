{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sanic-routing";
<<<<<<< HEAD
  version = "23.6.0";
=======
  version = "22.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic-routing";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-ual/vjL3M/nqlaRttJPoBcOYE3L/OAahbBLceUEVLXc=";
=======
    hash = "sha256-2T6WY0nzvr8Q9lBoStzmX7m7Ct35lcG53OSLcqxkEcY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sanic_routing"
  ];

  meta = with lib; {
    description = "Core routing component for the Sanic web framework";
    homepage = "https://github.com/sanic-org/sanic-routing";
    changelog = "https://github.com/sanic-org/sanic-routing/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
