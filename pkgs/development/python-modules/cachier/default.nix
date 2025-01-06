{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
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
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-cachier";
    repo = "cachier";
    rev = "refs/tags/v${version}";
    hash = "sha256-VApP1DRs+mjx+SELpdDOm2Sa7zBYHDqD/htFF/eNLu0=";
  };

  pythonRemoveDeps = [ "setuptools" ];

  nativeBuildInputs = [
    setuptools
  ];

  dependencies = [
    watchdog
    portalocker
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
  ];

  preBuild = ''
    export HOME="$(mktemp -d)"
  '';

  pythonImportsCheck = [ "cachier" ];

  meta = {
    homepage = "https://github.com/python-cachier/cachier";
    description = "Persistent, stale-free, local and cross-machine caching for functions";
    mainProgram = "cachier";
    maintainers = with lib.maintainers; [ pbsds ];
    license = lib.licenses.mit;
  };
}
