{ lib
, aiohttp
, buildPythonPackage
, coreutils
, fetchFromGitHub
, google-auth
, google-auth-oauthlib
, google-cloud-pubsub
, pydantic
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, requests-oauthlib
}:

buildPythonPackage rec {
  pname = "google-nest-sdm";
  version = "3.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "python-google-nest-sdm";
    rev = "refs/tags/${version}";
    hash = "sha256-NNHkcOCoG5Xagc0jTR50uHMA5mMgsh3BIzVJ77OEEjk=";
  };

  propagatedBuildInputs = [
    aiohttp
    google-auth
    google-auth-oauthlib
    google-cloud-pubsub
    pydantic
    requests-oauthlib
  ];

  __darwinAllowLocalNetworking = true;

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
