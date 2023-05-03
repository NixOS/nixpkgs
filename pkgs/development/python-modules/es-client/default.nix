{ lib
, buildPythonPackage
, certifi
, click
, elastic-transport
, elasticsearch8
, fetchFromGitHub
, hatchling
, mock
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, six
, voluptuous
}:

buildPythonPackage rec {
  pname = "es-client";
  version = "8.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "untergeek";
    repo = "es_client";
    rev = "refs/tags/v${version}";
    hash = "sha256-DJIo0yFJGR9gw5UJnmgnBFZx0uXUEW3rWT49jhfnXkQ=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    certifi
    click
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

  pythonImportsCheck = [
    "es_client"
  ];

  disabledTests = [
    # Tests require network access
    "test_bad_version_raises"
    "test_client_info"
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
