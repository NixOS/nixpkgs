{
  lib,
  aiohttp,
  brotli,
  buildPythonPackage,
  fetchPypi,
  google-auth,
  google-cloud-testutils,
  google-crc32c,
  mock,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-resumable-media";
  version = "2.8.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_resumable_media";
    inherit version;
    hash = "sha256-8RV+2LRplNYKG8QyVE22I1IEMRNoTU4DDuAud+vpoa4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-auth
    google-crc32c
  ];

  optional-dependencies = {
    requests = [ requests ];
    aiohttp = [ aiohttp ];
  };

  nativeCheckInputs = [
    brotli
    google-cloud-testutils
    mock
    pytest-asyncio
    pytestCheckHook
  ]
  ++ optional-dependencies.requests;

  preCheck = ''
    # prevent shadowing imports
    rm -r google
    # fixture 'authorized_transport' not found
    rm tests/system/requests/test_upload.py
    # requires network
    rm tests/system/requests/test_download.py
  '';

  pythonImportsCheck = [
    "google._async_resumable_media"
    "google.resumable_media"
  ];

  meta = {
    description = "Utilities for Google Media Downloads and Resumable Uploads";
    homepage = "https://github.com/GoogleCloudPlatform/google-resumable-media-python";
    changelog = "https://github.com/googleapis/google-resumable-media-python/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
