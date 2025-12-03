{
  lib,
  stdenv,
  azure-identity,
  azure-storage-blob,
  billiard,
  buildPythonPackage,
  click-didyoumean,
  click-plugins,
  click-repl,
  click,
  cryptography,
  fetchFromGitHub,
  gevent,
  google-cloud-firestore,
  google-cloud-storage,
  kombu,
  moto,
  msgpack,
  pymongo,
  redis,
  pydantic,
  pytest-celery,
  pytest-click,
  pytest-subtests,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  python-dateutil,
  pyyaml,
  setuptools,
  vine,
  # The AMQP REPL depends on click-repl, which is incompatible with our version
  # of click.
  withAmqpRepl ? false,
}:

buildPythonPackage rec {
  pname = "celery";
  version = "5.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "celery";
    repo = "celery";
    tag = "v${version}";
    hash = "sha256-+sickqRfSkBxhcO0W9na6Uov4kZ7S5oqpXXKX0iRQ0w=";
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
    kombu
    python-dateutil
    vine
  ]
  ++ lib.optionals withAmqpRepl [
    click-repl
  ];

  optional-dependencies = {
    auth = [ cryptography ];
    azureblockblob = [
      azure-identity
      azure-storage-blob
    ];
    gevent = [ gevent ];
    gcs = [
      google-cloud-firestore
      google-cloud-storage
    ];
    mongodb = [ pymongo ];
    msgpack = [ msgpack ];
    yaml = [ pyyaml ];
    redis = [ redis ];
    pydantic = [ pydantic ];
  };

  nativeCheckInputs = [
    moto
    pytest-celery
    pytest-click
    pytest-subtests
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
    # seems to only fail on higher core counts
    # AssertionError: assert 3 == 0
    "test_setup_security_disabled_serializers"
    # Test is flaky, especially on hydra
    "test_ready"
    # Tests fail with pytest-xdist
    "test_itercapture_limit"
    "test_stamping_headers_in_options"
    "test_stamping_with_replace"

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
    changelog = "https://github.com/celery/celery/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "celery";
  };
}
