{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, python-socks
, pythonOlder
, tldextract
, whodap
}:

buildPythonPackage rec {
  pname = "asyncwhois";
  version = "1.0.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pogzyb";
    repo = "asyncwhois";
    rev = "refs/tags/v${version}";
    hash = "sha256-5T/h4YzODH7zFyQpG8qVZetTK7V+Ii9jc+MQFgMUA8w=";
  };

  propagatedBuildInputs = [
    python-socks
    tldextract
    whodap
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "python-socks[asyncio]" "python-socks"
  '';

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

  pythonImportsCheck = [
    "asyncwhois"
  ];

  meta = with lib; {
    description = "Python module for retrieving WHOIS information";
    homepage = "https://github.com/pogzyb/asyncwhois";
    changelog = "https://github.com/pogzyb/asyncwhois/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
