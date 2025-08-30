{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  click,
  watchdog,
  portalocker,
  pytestCheckHook,
  pytest-cov-stub,
  sqlalchemy,
  pymongo,
  dnspython,
  pymongo-inmemory,
  pandas,
  birch,
}:

buildPythonPackage rec {
  pname = "cachier";
  version = "4.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-cachier";
    repo = "cachier";
    tag = "v${version}";
    hash = "sha256-FmrwH5Ksmgt0HA5eUN5LU36P5sY4PymRKsUWVkQlvBo=";
  };

  pythonRemoveDeps = [ "setuptools" ];

  nativeBuildInputs = [
    setuptools
  ];

  dependencies = [
    watchdog
    portalocker
    # not listed as dep, but needed to run main script entrypoint
    click
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    sqlalchemy
    pymongo
    dnspython
    pymongo-inmemory
    pandas
    birch
  ];

  disabledTests = [
    # touches network
    "test_mongetter_default_param"
    "test_stale_after_applies_dynamically"
    "test_next_time_applies_dynamically"
    "test_wait_for_calc_"
    "test_precache_value"
    "test_ignore_self_in_methods"
    "test_mongo_index_creation"
    "test_mongo_core"

    # don't test formatting
    "test_flake8"

    # slow, spawns 800+ threads
    "test_inotify_instance_limit_reached"

    # timing sensitive
    "test_being_calc_next_time"
    "test_pickle_being_calculated"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # sensitive to host file system
    # Unhandled exception in FSEventsEmitter -  RuntimeError: Cannot add watch - it is already scheduled
    "test_bad_cache_file"
    "test_delete_cache_file"
  ];

  disabledTestPaths = [
    # Keeps breaking due to concurrent access or failing to close the db between tests.
    "tests/test_sql_core.py"
  ];

  preBuild = ''
    export HOME="$(mktemp -d)"
  '';

  pythonImportsCheck = [ "cachier" ];

  meta = {
    homepage = "https://github.com/python-cachier/cachier";
    changelog = "https://github.com/python-cachier/cachier/releases/tag/${src.tag}";
    description = "Persistent, stale-free, local and cross-machine caching for functions";
    mainProgram = "cachier";
    maintainers = with lib.maintainers; [ pbsds ];
    license = lib.licenses.mit;
  };
}
