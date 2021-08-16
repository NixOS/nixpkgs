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
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4LGSB7KU+RGvjSQ/w1vXxa5fkfFT4C5omhk/LnGSUng=";
  };

  propagatedBuildInputs = [
    google-cloud-core
    grpc_google_iam_v1
    libcst
    proto-plus
    sqlparse
  ];

  checkInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google
  '';

  disabledTestPaths = [
    # Requires credentials
    "tests/system/test_system.py"
    "tests/system/test_system_dbapi.py"
    "tests/unit/spanner_dbapi/test_connect.py"
    "tests/unit/spanner_dbapi/test_connection.py"
    "tests/unit/spanner_dbapi/test_cursor.py"
  ];

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
