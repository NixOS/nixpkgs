{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aenum,
  aiohttp,
  importlib-metadata,
  isodate,
  nest-asyncio,
  pytestCheckHook,
  pythonOlder,
  mock,
  pyhamcrest,
  pyyaml,
  radish-bdd,
}:

buildPythonPackage rec {
  pname = "gremlinpython";
  version = "3.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "tinkerpop";
    rev = "refs/tags/${version}";
    hash = "sha256-2viZXksHNFynOm6+1Vo2a8xrXl4pQcAxAVgehp5y6us=";
  };

  sourceRoot = "${src.name}/gremlin-python/src/main/python";

  postPatch = ''
    sed -i '/pytest-runner/d' setup.py

    substituteInPlace setup.py \
      --replace 'importlib-metadata<5.0.0' 'importlib-metadata' \
      --replace "os.getenv('VERSION', '?').replace('-SNAPSHOT', '.dev-%d' % timestamp)" '"${version}"'
  '';

  # setup-requires requirements
  nativeBuildInputs = [ importlib-metadata ];

  propagatedBuildInputs = [
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
    substituteInPlace setup.cfg --replace 'addopts' '#addopts'
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
  pytestFlagsArray =
    let
      fullDisabled = builtins.concatStringsSep " or " [
        "test_transaction_commit"
        "test_transaction_rollback"
        "test_transaction_no_begin"
        "test_multi_commit_transaction"
        "test_multi_rollback_transaction"
        "test_multi_commit_and_rollback"
        "test_transaction_close_tx"
        "test_transaction_close_tx_from_parent"
      ];
    in
    [
      # disabledTests doesn't quite allow us to be precise enough for this
      "-k 'not ((TestFunctionalGraphSONIO and (test_timestamp or test_datetime or test_uuid)) or ${fullDisabled})'"
    ];

  meta = with lib; {
    description = "Gremlin-Python implements Gremlin, the graph traversal language of Apache TinkerPop, within the Python language";
    homepage = "https://tinkerpop.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ris ];
  };
}
