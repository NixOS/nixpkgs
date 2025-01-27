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
}:

buildPythonPackage rec {
  pname = "dbt-common";
  version = "1.14.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-common";
    # Unfortunately, upstream doesn't tag commits on GitHub, and the pypi source
    # doesn't include tests. TODO: Write an update script that will detect the
    # version from `dbt_common/__about__.py`.
    rev = "965ad815f0dd546678d2595a3010d81f344f8b73";
    hash = "sha256-63gWkETi52uOrO0FTPwM831UHECqcyCtb7wVHQuujnc=";
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

  pythonImportsCheck = [ "dbt_common" ];

  meta = {
    description = "Shared common utilities for dbt-core and adapter implementations use";
    homepage = "https://github.com/dbt-labs/dbt-common";
    changelog = "https://github.com/dbt-labs/dbt-common/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
