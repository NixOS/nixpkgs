{
  lib,
  buildPythonPackage,
  certifi,
  click,
  dotmap,
  ecs-logging,
  elastic-transport,
  elasticsearch8,
  fetchFromGitHub,
  hatchling,
  mock,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  pyyaml,
  requests,
  six,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "es-client";
  version = "8.13.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "untergeek";
    repo = "es_client";
    rev = "refs/tags/v${version}";
    hash = "sha256-aJ7BDS/0qi7NsFQBRxkMYXbOLhH0P/IRKhJHysowcvk=";
  };

  pythonRelaxDeps = true;

  build-system = [ hatchling ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  dependencies = [
    certifi
    click
    dotmap
    ecs-logging
    elastic-transport
    elasticsearch8
    pyyaml
    six
    voluptuous
  ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "es_client" ];

  disabledTests = [
    # Tests require network access
    "test_bad_version_raises"
    "test_basic_operation"
    "test_basic_operation"
    "test_client_info"
    "test_logging_options_ecs"
    "test_logging_options_json"
    "test_multiple_hosts_raises"
    "test_non_dict_passed"
    "test_skip_version_check"
  ];

  meta = with lib; {
    description = "Module for building Elasticsearch client objects";
    homepage = "https://github.com/untergeek/es_client";
    changelog = "https://github.com/untergeek/es_client/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
