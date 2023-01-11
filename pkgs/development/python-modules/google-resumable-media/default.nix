{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, google-auth
, google-cloud-testutils
, google-crc32c
, mock
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "google-resumable-media";
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jVUYUC+SuezISsRneb1PCWlOyzujij58pzeobRXLyh8=";
  };

  propagatedBuildInputs = [
    google-auth
    google-crc32c
  ];

  passthru.optional-dependencies = {
    requests = [
      requests
    ];
    aiohttp = [
      aiohttp
    ];
  };

  checkInputs = [
    google-cloud-testutils
    mock
    pytest-asyncio
    pytestCheckHook
  ] ++ passthru.optional-dependencies.requests;

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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
