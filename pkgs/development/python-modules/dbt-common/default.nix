{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

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
  numpy,
}:

buildPythonPackage rec {
  pname = "dbt-common";
  version = "1.11.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-common";
    # Unfortunatly, upstream doesn't tag commits on GitHub, and the pypi source
    # doesn't include tests. TODO: Write an update script that will detect the
    # version from `dbt_common/__about__.py`.
    rev = "ed11c6ceb4f29d4a79489469309d9ce9dd1757e6";
    hash = "sha256-JA6hFQwF7h1tXyCxBVKGgyevdTxyYeN3I/Bwy9uoC0Y=";
  };

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "protobuf"
    "agate"
    "deepdiff"
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
  pythonImportsCheck = [ "dbt_common" ];

  meta = {
    description = "Shared common utilities for dbt-core and adapter implementations use";
    homepage = "https://github.com/dbt-labs/dbt-common";
    changelog = "https://github.com/dbt-labs/dbt-common/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
