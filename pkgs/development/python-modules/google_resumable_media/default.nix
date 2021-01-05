{ lib
, buildPythonPackage
, fetchPypi
, google_auth
, google_cloud_testutils
, google_crc32c
, mock
, pytestCheckHook
, pytest-asyncio
, requests
}:

buildPythonPackage rec {
  pname = "google-resumable-media";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hwxdgsqh6933kp4jkv6hwwdcqs7bgjn9j08ga399njv3s9b367f";
  };

  propagatedBuildInputs = [ google_auth google_crc32c requests ];

  checkInputs = [ google_auth google_cloud_testutils mock pytestCheckHook pytest-asyncio ];

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
