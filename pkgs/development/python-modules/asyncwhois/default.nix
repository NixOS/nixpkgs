{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  python-dateutil,
  python-socks,
  tldextract,
  whodap,
}:

buildPythonPackage (finalAttrs: {
  pname = "asyncwhois";
  version = "1.1.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pogzyb";
    repo = "asyncwhois";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZokAOqnHmCNzMV45ZuniU0Bt36O+Kd29KK3FOOSpdFo=";
  };

  build-system = [ hatchling ];

  dependencies = [
    python-dateutil
    python-socks
    tldextract
    whodap
  ];

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

  meta = {
    description = "Python module for retrieving WHOIS information";
    homepage = "https://github.com/pogzyb/asyncwhois";
    changelog = "https://github.com/pogzyb/asyncwhois/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
