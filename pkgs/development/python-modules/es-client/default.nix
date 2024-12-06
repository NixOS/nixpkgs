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
  pyyaml,
  requests,
  six,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "es-client";
  version = "8.15.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "untergeek";
    repo = "es_client";
    rev = "refs/tags/v${version}";
    hash = "sha256-7vkpZNY333DYj9klzm1YG5ccxsu+LrP7WOWPH1KCfFA=";
  };

  pythonRelaxDeps = true;

  build-system = [ hatchling ];

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
    # Test wants to handle credentials
    "test_logging_options_from_config_file"
    # es_client.exceptions.ConfigurationError: Must populate both username and password, or leave both empty
    "test_exit_if_not_master "
  ];

  meta = with lib; {
    description = "Module for building Elasticsearch client objects";
    homepage = "https://github.com/untergeek/es_client";
    changelog = "https://github.com/untergeek/es_client/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
