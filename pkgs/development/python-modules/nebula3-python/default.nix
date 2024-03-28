{ lib
, buildPythonPackage
, fetchFromGitHub
, pdm-backend
, future
, httplib2
, pythonOlder
, pytz
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "nebula3-python";
  version = "3.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vesoft-inc";
    repo = "nebula-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-T9lZVYov6tQ8QRM2QtOGyolHk3O5FSb3xq70nS2Rr6c=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    future
    httplib2
    pytz
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nebula3"
  ];

  disabledTestPaths = [
    # Tests require a running thrift instance
    "tests/test_connection.py"
    "tests/test_data_from_server.py"
    "tests/test_graph_storage_client.py"
    "tests/test_meta_cache.py"
    "tests/test_parameter.py"
    "tests/test_pool.py"
    "tests/test_session.py"
    "tests/test_session_pool.py"
    "tests/test_ssl_connection.py"
    "tests/test_ssl_pool.py"
  ];

  meta = with lib; {
    description = "Client API of Nebula Graph in Python";
    homepage = "https://github.com/vesoft-inc/nebula-python";
    changelog = "https://github.com/vesoft-inc/nebula-python/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
