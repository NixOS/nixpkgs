{ lib
, aiohttp
<<<<<<< HEAD
, buildPythonPackage
, fetchFromGitHub
, orjson
, pythonOlder
, typing-extensions
=======
, aiounittest
, buildPythonPackage
, fetchFromGitHub
, ffmpeg-python
, pytestCheckHook
, pythonOlder
, requests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "reolink-aio";
<<<<<<< HEAD
  version = "0.7.9";
=======
  version = "0.5.15";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "starkillerOG";
    repo = "reolink_aio";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-+1FZzgVaj2hphSTFlOtaYH3o++kC/aaahU8i8urdme0=";
  };

  propagatedBuildInputs = [
    aiohttp
    orjson
    typing-extensions
=======
    hash = "sha256-YTBx0tMWSyy6A1OuTBmfEpRnZE4gHLIY5qFH9YL+YEo=";
  };

  postPatch = ''
    # Packages in nixpkgs is different than the module name
    substituteInPlace setup.py \
      --replace "ffmpeg" "ffmpeg-python"
  '';
  propagatedBuildInputs = [
    aiohttp
    ffmpeg-python
    requests
  ];

  doCheck = false; # all testse require a network device

  nativeCheckInputs = [
    aiounittest
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/test.py"
  ];

  disabledTests = [
    # Tests require network access
    "test1_settings"
    "test2_states"
    "test3_images"
    "test4_properties"
    "test_succes"
    "test_wrong_host"
    "test_wrong_password"
    "test_wrong_user"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "reolink_aio"
  ];

<<<<<<< HEAD
  # All tests require a network device
  doCheck = false;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Module to interact with the Reolink IP camera API";
    homepage = "https://github.com/starkillerOG/reolink_aio";
    changelog = "https://github.com/starkillerOG/reolink_aio/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
