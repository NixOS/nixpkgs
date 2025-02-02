{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  google-auth,
  google-cloud-testutils,
  google-crc32c,
  mock,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-resumable-media";
  version = "2.7.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "google_resumable_media";
    inherit version;
    hash = "sha256-UoCu1GKfK2C4R7DUL5hX/Uk1wRryZnRN8z2AdMrpL+A=";
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
    google-cloud-testutils
    mock
    pytest-asyncio
    pytestCheckHook
  ] ++ optional-dependencies.requests;

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

  meta = with lib; {
    description = "Utilities for Google Media Downloads and Resumable Uploads";
    homepage = "https://github.com/GoogleCloudPlatform/google-resumable-media-python";
    changelog = "https://github.com/googleapis/google-resumable-media-python/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
