{ lib
, aiohttp
, buildPythonPackage
, coreutils
, fetchFromGitHub
, google-auth
, google-auth-oauthlib
, google-cloud-pubsub
<<<<<<< HEAD
, pydantic
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, requests-oauthlib
}:

buildPythonPackage rec {
  pname = "google-nest-sdm";
<<<<<<< HEAD
  version = "3.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.10";
=======
  version = "2.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "python-google-nest-sdm";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-NNHkcOCoG5Xagc0jTR50uHMA5mMgsh3BIzVJ77OEEjk=";
=======
    hash = "sha256-HQzU6no/DV2QOC+LV7kUSrygTwgAvfMSmYIKaBd/PCE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
    google-auth
    google-auth-oauthlib
    google-cloud-pubsub
<<<<<<< HEAD
    pydantic
    requests-oauthlib
  ];

  __darwinAllowLocalNetworking = true;

=======
    requests-oauthlib
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    coreutils
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google_nest_sdm"
  ];

  disabledTests = [
    "test_clip_preview_transcode"
    "test_event_manager_event_expiration_with_transcode"
  ];

  meta = with lib; {
    description = "Module for Google Nest Device Access using the Smart Device Management API";
    homepage = "https://github.com/allenporter/python-google-nest-sdm";
    changelog = "https://github.com/allenporter/python-google-nest-sdm/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
