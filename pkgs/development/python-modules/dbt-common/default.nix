{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  agate,
  colorama,
  deepdiff,
  isodate,
  jinja2,
  jsonschema,
  mashumaro,
  pathspec,
  protobuf,
  python-dateutil,
  requests,
  typing-extensions,

  # tests
  pytestCheckHook,
  pytest-mock,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "dbt-common";
  version = "1.22.0";
  pyproject = true;

  # No tags on GitHub
  src = fetchPypi {
    pname = "dbt_common";
    inherit version;
    hash = "sha256-6cdTMVCCB6SNEUsQtzKUBnKuJgwfttl7o2+zBp8Fu5g=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "agate"
    "deepdiff"
    # 0.6.x -> 0.7.2 doesn't seem too risky at a glance
    # https://pypi.org/project/isodate/0.7.2/
    "isodate"
  ];

  dependencies = [
    agate
    colorama
    deepdiff
    isodate
    jinja2
    jsonschema
    mashumaro
    pathspec
    protobuf
    python-dateutil
    requests
    typing-extensions
  ] ++ mashumaro.optional-dependencies.msgpack;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    pytest-mock
  ];

  disabledTests = [
    # Assertion errors (TODO: Notify upstream)
    "test_create_print_json"
    "test_events"
    "test_extra_dict_on_event"
  ];

  # No tests in the pypi archive
  doCheck = false;

  pythonImportsCheck = [ "dbt_common" ];

  meta = {
    description = "Shared common utilities for dbt-core and adapter implementations use";
    homepage = "https://github.com/dbt-labs/dbt-common";
    changelog = "https://github.com/dbt-labs/dbt-common/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
