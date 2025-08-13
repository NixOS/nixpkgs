{
  lib,
  buildPythonPackage,
  certifi,
  click,
  cryptography,
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
  tiered-debug,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "es-client";
  version = "8.18.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "untergeek";
    repo = "es_client";
    tag = "v${version}";
    hash = "sha256-siB17xVRS/eeKOsJcWdh4foOHXbeV8wwRclXDHodADM=";
  };

  pythonRelaxDeps = true;

  build-system = [ hatchling ];

  dependencies = [
    certifi
    click
    cryptography
    dotmap
    ecs-logging
    elastic-transport
    elasticsearch8
    pyyaml
    tiered-debug
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
    # Tests require local Elasticsearch instance
    "test_bad_version_raises"
    "test_basic_operation"
    "test_client_info"
    "test_client_info"
    "test_exit_if_not_master"
    "test_multiple_hosts_raises"
    "test_skip_version_check"
    "TestCLIExample"
  ];

  meta = with lib; {
    description = "Module for building Elasticsearch client objects";
    homepage = "https://github.com/untergeek/es_client";
    changelog = "https://github.com/untergeek/es_client/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
