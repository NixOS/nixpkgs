{ lib
, buildPythonPackage
, fetchPypi
, grpc_google_iam_v1
, google-cloud-core
, google-cloud-testutils
, libcst
, mock
, proto-plus
, pytestCheckHook
, pytest-asyncio
, sqlparse
}:

buildPythonPackage rec {
  pname = "google-cloud-spanner";
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19656140f180aef84e023c3a8fd534ac964247a52199317ea33abc701d5a8c5a";
  };

  propagatedBuildInputs = [ google-cloud-core grpc_google_iam_v1 libcst proto-plus sqlparse ];

  checkInputs = [ google-cloud-testutils mock pytestCheckHook pytest-asyncio ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google
    # disable tests which require credentials
    rm tests/system/test_{system,system_dbapi}.py
    rm tests/unit/spanner_dbapi/test_{connect,connection,cursor}.py
  '';

  pythonImportsCheck = [
    "google.cloud.spanner_admin_database_v1"
    "google.cloud.spanner_admin_instance_v1"
    "google.cloud.spanner_dbapi"
    "google.cloud.spanner_v1"
  ];

  meta = with lib; {
    description = "Cloud Spanner API client library";
    homepage = "https://github.com/googleapis/python-spanner";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
