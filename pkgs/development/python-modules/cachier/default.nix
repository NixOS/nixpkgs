{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  click,
  watchdog,
  portalocker,
  pytestCheckHook,
  pytest-cov-stub,
  pymongo,
  dnspython,
  pymongo-inmemory,
  pandas,
  birch,
}:

buildPythonPackage rec {
  pname = "cachier";
  version = "3.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-cachier";
    repo = "cachier";
    rev = "refs/tags/v${version}";
    hash = "sha256-siighT6hMicN+F/LIXfUAPQ2kkRiyk7CtjqmyC/qCFg=";
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

    # timing sensitive
    "test_being_calc_next_time"
    "test_pickle_being_calculated"
  ];

  preBuild = ''
    export HOME="$(mktemp -d)"
  '';

  pythonImportsCheck = [ "cachier" ];

  meta = {
    homepage = "https://github.com/python-cachier/cachier";
    changelog = "https://github.com/python-cachier/cachier/releases/tag/v${version}";
    description = "Persistent, stale-free, local and cross-machine caching for functions";
    mainProgram = "cachier";
    maintainers = with lib.maintainers; [ pbsds ];
    license = lib.licenses.mit;
  };
}
