{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, google_auth
, google_cloud_iam
, google_cloud_core
, google_cloud_kms
, google_cloud_testutils
, google_resumable_media
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-storage";
  version = "1.35.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17kal75wmyjpva7g04cb9yg7qbyrgwfn575z4gqijd4gz2r0sp2m";
  };

  propagatedBuildInputs = [
    google_auth
    google_cloud_core
    google_resumable_media
  ];

  checkInputs = [
    google_cloud_iam
    google_cloud_kms
    google_cloud_testutils
    mock
    pytestCheckHook
  ];

  # disable tests which require credentials and network access
  disabledTests = [
    "create"
    "download"
    "get"
    "post"
    "test_build_api_url"
  ];

  pytestFlagsArray = [
    "--ignore=tests/unit/test_bucket.py"
    "--ignore=tests/system/test_system.py"
  ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [ "google.cloud.storage" ];

  meta = with lib; {
    description = "Google Cloud Storage API client library";
    homepage = "https://github.com/googleapis/python-storage";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
