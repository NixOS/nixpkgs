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
  version = "1.36.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "89d3a101c8ca3aae7614253a03a2e7fe77c5e799469df2d4ec44044cccac1ad8";
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
