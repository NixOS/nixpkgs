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
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "google-nest-sdm";
  version = "1.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "python-google-nest-sdm";
    rev = version;
    sha256 = "sha256-oaUR/2G8dcQ5A4YZeLTSzyMNLI8a29pSoEtTdWvTVKE=";
  };

  propagatedBuildInputs = [
    aiohttp
    google-auth
    google-auth-oauthlib
    google-cloud-pubsub
    requests_oauthlib
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
