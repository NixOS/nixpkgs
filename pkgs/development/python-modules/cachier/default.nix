{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pythonRelaxDepsHook
, setuptools
, watchdog
, portalocker
, pathtools
, pytestCheckHook
, pymongo
, dnspython
, pymongo-inmemory
, pandas
}:

buildPythonPackage rec {
  pname = "cachier";
  version = "2.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nm98LT87Z7yErKvIqMp93OEX9TDojqqtItgryHgSQJQ=";
  };

  pythonRemoveDeps = [ "setuptools" ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = [
    watchdog
    portalocker
    pathtools
  ];

  preCheck = ''
    substituteInPlace pytest.ini \
      --replace  \
        "--cov" \
        "#--cov"
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pymongo
    dnspython
    pymongo-inmemory
    pandas
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

  pythonImportsCheck = [
    "cachier"
    "cachier.scripts"
  ];

  meta = {
    homepage = "https://github.com/python-cachier/cachier";
    description = "Persistent, stale-free, local and cross-machine caching for functions";
    maintainers = with lib.maintainers; [ pbsds ];
    license = lib.licenses.mit;
  };
}
