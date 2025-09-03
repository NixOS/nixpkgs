{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  dbt-protos,
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
  version = "1.28.0-unstable-2025-08-14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbt-labs";
    repo = "dbt-common";
    rev = "dd34e0a0565620863ff70c0b02421d84fcee8a02"; # They don't tag releases
    hash = "sha256-hG6S+IIAR3Cu69oFapQUVoCdaiEQYeMQ/ekBuAXxPrI=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "agate"
    "deepdiff"
    # 0.6.x -> 0.7.2 doesn't seem too risky at a glance
    # https://pypi.org/project/isodate/0.7.2/
    "isodate"
    "protobuf"
  ];

  dependencies = [
    dbt-protos
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
  ]
  ++ mashumaro.optional-dependencies.msgpack;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    pytest-mock
  ];

  disabledTests = [
    # flaky test: https://github.com/dbt-labs/dbt-common/issues/280
    "TestFindMatching"
  ];

  pythonImportsCheck = [ "dbt_common" ];

  meta = {
    description = "Shared common utilities for dbt-core and adapter implementations use";
    homepage = "https://github.com/dbt-labs/dbt-common";
    changelog = "https://github.com/dbt-labs/dbt-common/blob/main/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
