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
<<<<<<< HEAD
  exceptiongroup,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  tzlocal,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  vine,
  # The AMQP REPL depends on click-repl, which is incompatible with our version
  # of click.
  withAmqpRepl ? false,
}:

buildPythonPackage rec {
  pname = "celery";
<<<<<<< HEAD
  version = "5.6.0";
=======
  version = "5.5.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "celery";
    repo = "celery";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-BKF+p35Z5r/WRjuOaSFtESkbo+N+tbd0R40EWl0iU9I=";
=======
    hash = "sha256-+sickqRfSkBxhcO0W9na6Uov4kZ7S5oqpXXKX0iRQ0w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    exceptiongroup
    kombu
    python-dateutil
    tzlocal
=======
    kombu
    python-dateutil
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
    "test_uses_utc_timezone"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    changelog = "https://github.com/celery/celery/blob/${src.tag}/Changelog.rst";
=======
    changelog = "https://github.com/celery/celery/releases/tag/v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "celery";
  };
}
