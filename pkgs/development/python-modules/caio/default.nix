{ lib
, aiomisc
, buildPythonPackage
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "caio";
<<<<<<< HEAD
  version = "0.9.13";
=======
  version = "0.9.12";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-Q87NuL6yZ5uKImQqqdKTMWNyfUOb4NaZDEvNdqZbHDk=";
=======
    hash = "sha256-uMq/3yWP9OwaVxixGAFCLMsDPoJhmIuG0I7hO7AnIOk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    aiomisc
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "caio"
  ];

  meta = with lib; {
    description = "File operations with asyncio support";
    homepage = "https://github.com/mosquito/caio";
    changelog = "https://github.com/mosquito/caio/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
