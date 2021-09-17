{ lib
, buildPythonPackage
, fetchPypi
, aiounittest
, google-api-core
, google-cloud-testutils
, google-cloud-core
, mock
, proto-plus
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-firestore";
  version = "2.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e2eb65ccd75c6579214fb2099cfb98c57b2b4907ccb38a2ed21f00f492b7a50";
  };

  propagatedBuildInputs = [
    google-api-core
    google-cloud-core
    proto-plus
  ];

  checkInputs = [
    aiounittest
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  preCheck = ''
    # do not shadow imports
    rm -r google
  '';

  disabledTestPaths = [
    # Tests are broken
    "tests/system/test_system.py"
    "tests/system/test_system_async.py"
    # requires credentials
    "tests/unit/v1/test_bulk_writer.py"
  ];

  disabledTests = [
    # requires credentials
    "test_collections"
  ];

  pythonImportsCheck = [
    "google.cloud.firestore_v1"
    "google.cloud.firestore_admin_v1"
  ];

  meta = with lib; {
    description = "Google Cloud Firestore API client library";
    homepage = "https://github.com/googleapis/python-firestore";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
