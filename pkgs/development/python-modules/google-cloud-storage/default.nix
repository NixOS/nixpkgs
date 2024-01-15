{ lib
, buildPythonPackage
, fetchPypi
, google-auth
, google-cloud-core
, google-cloud-iam
, google-cloud-kms
, google-cloud-testutils
, google-resumable-media
, mock
, protobuf
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "google-cloud-storage";
  version = "2.13.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9i3Ex7bNQ2DQcuPesoA1+9rUkaw9mwsYFaEtrqEPN8c=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  pythonRelaxDeps = [
    "google-auth"
  ];

  propagatedBuildInputs = [
    google-auth
    google-cloud-core
    google-resumable-media
    requests
  ];

  passthru.optional-dependencies = {
    protobuf = [
      protobuf
    ];
  };

  nativeCheckInputs = [
    google-cloud-iam
    google-cloud-kms
    google-cloud-testutils
    mock
    pytestCheckHook
  ];

  # Disable tests which require credentials and network access
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
    "test_ctor_w_custom_endpoint_use_auth"
  ];

  disabledTestPaths = [
    "tests/unit/test_bucket.py"
    "tests/system/test_blob.py"
    "tests/system/test_bucket.py"
    "tests/system/test_fileio.py"
    "tests/system/test_kms_integration.py"
    "tests/unit/test_transfer_manager.py"
  ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google

    # requires docker and network
    rm tests/conformance/test_conformance.py
  '';

  pythonImportsCheck = [
    "google.cloud.storage"
  ];

  meta = with lib; {
    description = "Google Cloud Storage API client library";
    homepage = "https://github.com/googleapis/python-storage";
    changelog = "https://github.com/googleapis/python-storage/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
