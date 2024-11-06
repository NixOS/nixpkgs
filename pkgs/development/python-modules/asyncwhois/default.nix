{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  python-socks,
  pythonOlder,
  tldextract,
  whodap,
}:

buildPythonPackage rec {
  pname = "asyncwhois";
  version = "1.1.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pogzyb";
    repo = "asyncwhois";
    rev = "refs/tags/v${version}";
    hash = "sha256-y5JmAbrk9qJeNYejNcz5nI5bghaetUw1xkD8qgwOkao=";
  };

  build-system = [ hatchling ];

  dependencies = [
    python-socks
    tldextract
    whodap
  ] ++ python-socks.optional-dependencies.asyncio;

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require network access
    "test_pywhois_aio_get_hostname_from_ip"
    "test_pywhois_get_hostname_from_ip"
    "test_pywhois_aio_lookup_ipv4"
    "test_not_found"
    "test_aio_from_whois_cmd"
    "test_aio_get_hostname_from_ip"
    "test_from_whois_cmd"
    "test_get_hostname_from_ip"
    "test_whois_query_run"
    "test_whois_query_create_connection"
    "test_whois_query_send_and_recv"
    "test_input_parameters_for_domain_query"
    "test__get_top_level_domain"
  ];

  pythonImportsCheck = [ "asyncwhois" ];

  meta = with lib; {
    description = "Python module for retrieving WHOIS information";
    homepage = "https://github.com/pogzyb/asyncwhois";
    changelog = "https://github.com/pogzyb/asyncwhois/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
