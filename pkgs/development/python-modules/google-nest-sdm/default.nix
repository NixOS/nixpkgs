{ lib
, aiohttp
, asynctest
, buildPythonPackage
, coreutils
, fetchFromGitHub
, google-auth
, google-auth-oauthlib
, google-cloud-pubsub
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, requests-oauthlib
}:

buildPythonPackage rec {
  pname = "google-nest-sdm";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "python-google-nest-sdm";
    rev = "refs/tags/${version}";
    sha256 = "sha256-af1oYeNEQdz6HivAhvQY0xm3J4s+uXpcdema37oG15U=";
  };

  propagatedBuildInputs = [
    aiohttp
    google-auth
    google-auth-oauthlib
    google-cloud-pubsub
    requests-oauthlib
  ];

  checkInputs = [
    asynctest
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
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
