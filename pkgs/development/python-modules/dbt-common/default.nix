{
  lib,
  agate,
  buildPythonPackage,
  colorama,
  deepdiff,
  fetchPypi,
  hatchling,
  isodate,
  jinja2,
  jsonschema,
  mashumaro,
  pathspec,
  protobuf,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "dbt-common";
  version = "1.8.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "dbt_common";
    inherit version;
    hash = "sha256-ehZ+a3zznnWMY9NJx9LfRtkV1vHiIH0HEhsYWfMbmb4=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "agate" ];

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

  # Upstream stopped to tag the source fo rnow
  doCheck = false;

  nativeCheckInputs = [
    pytest-mock
    pytest-xdist
    pytestCheckHook
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
