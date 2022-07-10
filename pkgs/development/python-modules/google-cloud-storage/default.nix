{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, google-auth
, google-cloud-iam
, google-cloud-core
, google-cloud-kms
, google-cloud-testutils
, google-resumable-media
, mock
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-storage";
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X+JvE4GzDjzDKPRuE1McqFJUWPhwweMDxha963t/XGY=";
  };

  propagatedBuildInputs = [
    google-auth
    google-cloud-core
    google-resumable-media
  ];

  checkInputs = [
    google-cloud-iam
    google-cloud-kms
    google-cloud-testutils
    mock
    pytestCheckHook
  ];

  # disable tests which require credentials and network access
  disabledTests = [
    "create"
    "download"
    "get"
    "post"
    "upload"
    "test_build_api_url"
    "test_ctor_mtls"
    "test_hmac_key_crud"
    "test_list_buckets"
    "test_open"
    "test_anonymous_client_access_to_public_bucket"
  ];

  disabledTestPaths = [
    "tests/unit/test_bucket.py"
    "tests/system/test_blob.py"
    "tests/system/test_bucket.py"
    "tests/system/test_fileio.py"
    "tests/system/test_kms_integration.py"
  ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google

    # requires docker and network
    rm tests/conformance/test_conformance.py
  '';

  pythonImportsCheck = [ "google.cloud.storage" ];

  meta = with lib; {
    description = "Google Cloud Storage API client library";
    homepage = "https://github.com/googleapis/python-storage";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
