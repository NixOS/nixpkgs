{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, meteocalc
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioecowitt";
<<<<<<< HEAD
  version = "2023.5.0";
=======
  version = "2023.01.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-uEA3OA/QOQ/h6ZMnb5hGQXHyqNO+KLmDSZMQBvmRwtE=";
=======
    hash = "sha256-xOoKrGBkMEdpeiU1r27xlZp5s5sGJzvD7Ats+w6KR/o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
    meteocalc
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aioecowitt"
  ];

  meta = with lib; {
    description = "Wrapper for the EcoWitt protocol";
    homepage = "https://github.com/home-assistant-libs/aioecowitt";
    changelog = "https://github.com/home-assistant-libs/aioecowitt/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
