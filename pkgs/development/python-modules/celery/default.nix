{
  lib,
  stdenv,
  azure-identity,
  azure-storage-blob,
  billiard,
  boto3,
  brotli,
  brotlipy,
  buildPythonPackage,
  cassandra-driver,
  click,
  click-didyoumean,
  click-plugins,
  click-repl,
  cryptography,
  exceptiongroup,
  django,
  elastic-transport,
  elasticsearch,
  ephem,
  fetchFromGitHub,
  gevent,
  google-cloud-firestore,
  google-cloud-storage,
  grpcio,
  isPyPy,
  kazoo,
  kombu,
  moto,
  pydantic,
  pydocumentdb,
  pylibmc,
  pytest-celery,
  pytest-click,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  python-dateutil,
  python-memcached,
  pyzmq,
  setuptools,
  tzlocal,
  sphinx-autobuild,
  tblib,
  urllib3,
  vine,
  zstandard,
  # The AMQP REPL depends on click-repl, which is incompatible with our version
  # of click.
  withAmqpRepl ? false,
}:

buildPythonPackage rec {
  pname = "celery";
  version = "5.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "celery";
    repo = "celery";
    tag = "v${version}";
    hash = "sha256-S84hLGwVVgxnUB6wnqU58tN56t/tQ79ZUni/iP5sx94=";
  };

  patches = lib.optionals (!withAmqpRepl) [
    ./remove-amqp-repl.patch
  ];

  build-system = [ setuptools ];

  dependencies = [
    billiard
    click
    click-didyoumean
    click-plugins
    exceptiongroup
    kombu
    python-dateutil
    tzlocal
    vine
  ]
  ++ lib.optionals withAmqpRepl [
    click-repl
  ];

  optional-dependencies = {
    # Everything commented is not packaged
    # see https://github.com/celery/celery/tree/main/requirements/extras
    arangodb = [
      # pyarango
    ];
    auth = [ cryptography ];
    azureblockblob = [
      azure-identity
      azure-storage-blob
    ];
    brotli = if isPyPy then [ brotlipy ] else [ brotli ];
    cassandra = [ cassandra-driver ];
    consul = [
      # python-consul2
    ];
    cosmosdbsql = [ pydocumentdb ];
    couchbase = [ ];
    couchdb = [
      # pycouchdb
    ];
    django = [ django ];
    dynamodb = [ boto3 ];
    elasticsearch = [
      elasticsearch
      elastic-transport
    ];
    eventlet = [ ];
    gcs = [
      google-cloud-firestore
      google-cloud-storage
      grpcio
    ];
    gevent = [ gevent ];
    memcache = [ pylibmc ];
    mongodb = kombu.optional-dependencies.mongodb;
    msgpack = kombu.optional-dependencies.msgpack;
    pydantic = [ pydantic ];
    pymemcache = [ python-memcached ];
    pyro = [ ];
    pytest = [
      pytest-celery
    ]
    ++ pytest-celery.optional-dependencies.all;
    redis = kombu.optional-dependencies.redis;
    s3 = [ boto3 ];
    slmq = [
      # softlayer-messaging
    ];
    solar = lib.optionals isPyPy [ ephem ];
    sphinxautobuild = [ sphinx-autobuild ];
    sqlalchemy = kombu.optional-dependencies.sqlalchemy;
    sqs = [
      boto3
      urllib3
    ]
    ++ kombu.optional-dependencies.sqs;
    tblib = [ tblib ];
    thread = [ ];
    yaml = kombu.optional-dependencies.yaml;
    zeromq = [ pyzmq ];
    zookeeper = [ kazoo ];
    zsdt = [ zstandard ];
  };

  nativeCheckInputs = [
    moto
    pytest-celery
    pytest-click
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTestPaths = [
    # test_eventlet touches network
    "t/unit/concurrency/test_eventlet.py"
    # test_multi tries to create directories under /var
    "t/unit/bin/test_multi.py"
    "t/unit/apps/test_multi.py"
    # Test requires moto<5
    "t/unit/backends/test_s3.py"
  ];

  disabledTests = [
    "msgpack"
    "test_check_privileges_no_fchown"
    "test_uses_utc_timezone"
    # seems to only fail on higher core counts
    # AssertionError: assert 3 == 0
    "test_setup_security_disabled_serializers"
    # Test is flaky, especially on hydra
    "test_ready"
    # Tests fail with pytest-xdist
    "test_itercapture_limit"
    "test_stamping_headers_in_options"
    "test_stamping_with_replace"
    # pymongo api compat
    # TypeError: InvalidDocument.__init__() missing 1 required positional argumen...
    "test_store_result"
    "test_store_result_with_request"

    # Celery tries to look up group ID (e.g. 30000)
    # which does not reliably succeed in the sandbox on linux,
    # so it throws a security error as if we were running as root.
    # https://github.com/celery/celery/blob/0527296acb1f1790788301d4395ba6d5ce2a9704/celery/platforms.py#L807-L814
    "test_regression_worker_startup_info"
    "test_check_privileges"

    # Flaky: Unclosed temporary file handle under heavy load (as in nixpkgs-review)
    "test_check_privileges_without_c_force_root_and_no_group_entry"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Too many open files on hydra
    "test_cleanup"
    "test_with_autoscaler_file_descriptor_safety"
    "test_with_file_descriptor_safety"
  ];

  pythonImportsCheck = [ "celery" ];

  meta = {
    description = "Distributed task queue";
    homepage = "https://github.com/celery/celery/";
    changelog = "https://github.com/celery/celery/blob/${src.tag}/Changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "celery";
  };
}
