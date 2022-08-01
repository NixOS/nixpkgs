{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-core
, libcst
, proto-plus
, mock
, pytestCheckHook
, pytest-asyncio
, google-cloud-testutils
}:

buildPythonPackage rec {
  pname = "google-cloud-datastore";
  version = "2.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/zqsy+xrgmjsSrybBpwCfphTGGVp2AOp+ANsYPSrVfA=";
  };

  propagatedBuildInputs = [
    google-api-core
    google-cloud-core
    libcst
    proto-plus
  ];

  checkInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  preCheck = ''
    # directory shadows imports
    rm -r google
  '';

  disabledTestPaths = [
    # Requires credentials
    "tests/system/test_allocate_reserve_ids.py"
    "tests/system/test_query.py"
    "tests/system/test_put.py"
    "tests/system/test_transaction.py"
  ];

  pythonImportsCheck = [
    "google.cloud.datastore"
    "google.cloud.datastore_admin_v1"
    "google.cloud.datastore_v1"
  ];

  meta = with lib; {
    description = "Google Cloud Datastore API client library";
    homepage = "https://github.com/googleapis/python-datastore";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
