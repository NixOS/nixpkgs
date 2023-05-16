{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiolyric";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-LDLpNuwkoPacI/a2NSlqUABRgwy+jAjGwOxmShLskso=";
=======
    hash = "sha256-yKeG0UCQ8haT1hvywoIwKQ519GK2wFg0wXaRTFeKYIk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
<<<<<<< HEAD
    # AssertionError, https://github.com/timmo001/aiolyric/issues/61
    "test_priority"
=======
    # AssertionError, https://github.com/timmo001/aiolyric/issues/5
    "test_location"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "aiolyric"
  ];

  meta = with lib; {
    description = "Python module for the Honeywell Lyric Platform";
    homepage = "https://github.com/timmo001/aiolyric";
    changelog = "https://github.com/timmo001/aiolyric/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
