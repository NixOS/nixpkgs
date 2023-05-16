{ lib
, aiohttp
, bluetooth-data-tools
, buildPythonPackage
, fetchFromGitHub
, orjson
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioshelly";
<<<<<<< HEAD
  version = "6.0.0";
=======
  version = "5.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-mB9BEVqbHcoUaygIgrtqk20wMJkL+dWpbeyG5VP4+sg=";
=======
    hash = "sha256-eqZyCQ96CasBlO++QcQ/HiVWWeB2jQltHXZRbIfub7Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
    bluetooth-data-tools
    orjson
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [
    "aioshelly"
  ];

  meta = with lib; {
    description = "Python library to control Shelly";
    homepage = "https://github.com/home-assistant-libs/aioshelly";
    changelog = "https://github.com/home-assistant-libs/aioshelly/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
