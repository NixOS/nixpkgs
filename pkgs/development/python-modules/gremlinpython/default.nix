{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  aenum,
  aiohttp,
  isodate,
  nest-asyncio,
  pytestCheckHook,
  pythonOlder,
  mock,
  pyhamcrest,
  pyyaml,
  radish-bdd,
  setuptools,
}:

buildPythonPackage rec {
  __structuredAttrs = true;

  pname = "gremlinpython";
  version = "3.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "tinkerpop";
    tag = version;
    hash = "sha256-dslSvtne+0mobjhjZDiO7crQE3aW5wEMWw7l3LkBTV8=";
  };

  patches = [
    (fetchpatch {
      name = "remove-async_timeout.pach";
      url = "https://github.com/apache/tinkerpop/commit/aa327ace6feaf6ccd3eca411f3b5f6f86f8571f6.patch";
      excludes = [ "gremlin-python/src/main/python/setup.py" ];
      hash = "sha256-NyXA9vffFem1EzhdNWuoYr7JPkT5DuKyl409LFj9AvQ=";
    })
  ];

  postPatch = ''
    cd gremlin-python/src/main/python

    substituteInPlace gremlin_python/__init__.py \
      --replace-fail ".dev1" ""
  '';

  build-system = [ setuptools ];

  pythonRemoveDeps = [
    "async-timeout"
  ];

  dependencies = [
    aenum
    aiohttp
    isodate
    nest-asyncio
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    pyhamcrest
    pyyaml
    radish-bdd
  ];

  # disable custom pytest report generation
  preCheck = ''
    export TEST_TRANSACTIONS='false'
  '';

  # many tests expect a running tinkerpop server
  disabledTestPaths = [
    "tests/driver/test_client.py"
    "tests/driver/test_driver_remote_connection.py"
    "tests/driver/test_driver_remote_connection_http.py"
    "tests/driver/test_driver_remote_connection_threaded.py"
    "tests/driver/test_web_socket_client_behavior.py"
    "tests/process/test_dsl.py"
    "tests/structure/io/test_functionalityio.py"
  ];

  disabledTests = [
    "TestFunctionalGraphSONIO and test_timestamp"
    "TestFunctionalGraphSONIO and test_datetime"
    "TestFunctionalGraphSONIO and test_uuid"
    "test_transaction_commit"
    "test_transaction_rollback"
    "test_transaction_no_begin"
    "test_multi_commit_transaction"
    "test_multi_rollback_transaction"
    "test_multi_commit_and_rollback"
    "test_transaction_close_tx"
    "test_transaction_close_tx_from_parent"
  ];

  meta = with lib; {
    changelog = "https://github.com/apache/tinkerpop/blob/${src.tag}/CHANGELOG.asciidoc";
    description = "Gremlin-Python implements Gremlin, the graph traversal language of Apache TinkerPop, within the Python language";
    homepage = "https://tinkerpop.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ris ];
  };
}
