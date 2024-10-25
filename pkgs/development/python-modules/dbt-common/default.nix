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
  version = "1.10.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "dbt_common";
    inherit version;
    hash = "sha256-z9n0bp3k+cLJXscCENG+U6xB4nkDjRinkoy7/T+bZ68=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "agate"
    "protobuf"
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
