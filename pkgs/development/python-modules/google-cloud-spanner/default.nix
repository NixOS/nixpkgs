{ lib
, buildPythonPackage
, deprecated
, fetchPypi
, google-api-core
, google-cloud-core
, google-cloud-testutils
, grpc-google-iam-v1
, libcst
, mock
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, sqlparse
, setuptools
}:

buildPythonPackage rec {
  pname = "google-cloud-spanner";
  version = "3.41.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jK2hHdYdxwsEmk/aDp7ArXZwZbhEloqIuLJ2ZwMs9YI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    deprecated
    google-api-core
    google-cloud-core
    grpc-google-iam-v1
    proto-plus
    protobuf
    sqlparse
  ] ++ google-api-core.optional-dependencies.grpc;

  passthru.optional-dependencies = {
    libcst = [
      libcst
    ];
  };

  nativeCheckInputs = [
    google-cloud-testutils
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google
  '';

  disabledTestPaths = [
    # Requires credentials
    "tests/system/test_backup_api.py"
    "tests/system/test_database_api.py"
    "tests/system/test_dbapi.py"
    "tests/system/test_instance_api.py"
    "tests/system/test_session_api.py"
    "tests/system/test_streaming_chunking.py"
    "tests/system/test_table_api.py"
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
    changelog = "https://github.com/googleapis/python-spanner/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
