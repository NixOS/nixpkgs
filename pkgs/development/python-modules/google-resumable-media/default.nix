{ lib
, buildPythonPackage
, fetchPypi
, google-auth
, google-cloud-testutils
, google-crc32c
, mock
, pytestCheckHook
, pytest-asyncio
, requests
}:

buildPythonPackage rec {
  pname = "google-resumable-media";
  version = "2.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-J8UmIL02TRyBFuqsTqKvy/uBrpE5+zGZZS/KwXJL+2w=";
  };

  propagatedBuildInputs = [ google-auth google-crc32c requests ];

  checkInputs = [ google-cloud-testutils mock pytestCheckHook pytest-asyncio ];

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
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
