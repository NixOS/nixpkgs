{
  lib,
  aiohttp,
  buildPythonPackage,
  coreutils,
  fetchFromGitHub,
  google-auth,
  google-auth-oauthlib,
  google-cloud-pubsub,
  mashumaro,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  pyyaml,
  requests-oauthlib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-nest-sdm";
  version = "9.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "python-google-nest-sdm";
    tag = version;
    hash = "sha256-BvyflbmtgLSRaAc465bN+5AcPwum0UBsSAWzwvelwIk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    google-auth
    google-auth-oauthlib
    google-cloud-pubsub
    mashumaro
    pyyaml
    requests-oauthlib
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    coreutils
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "google_nest_sdm" ];

  disabledTests = [
    "test_clip_preview_transcode"
    "test_event_manager_event_expiration_with_transcode"
  ];

  meta = with lib; {
    description = "Module for Google Nest Device Access using the Smart Device Management API";
    homepage = "https://github.com/allenporter/python-google-nest-sdm";
    changelog = "https://github.com/allenporter/python-google-nest-sdm/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "google_nest";
  };
}
