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
}:

buildPythonPackage rec {
  pname = "google-cloud-storage";
  version = "1.35.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dc076b6af6da991252416639cb93831f8e50c8328d5ac3fb8e03e40cd8de2290";
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
