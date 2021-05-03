{ lib
, aiodns
, asynctest
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, tldextract
}:

buildPythonPackage rec {
  pname = "asyncwhois";
  version = "0.3.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pogzyb";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wp6pwnc1inzzn9nhkwq9m9ab1aylw0hzq94w6p2dsm2njfqma8h";
  };

  propagatedBuildInputs = [
    aiodns
    tldextract
  ];

  checkInputs = [
    asynctest
    pytestCheckHook
  ];

  # Disable tests that require network access
  disabledTests = [
    "test_pywhois_aio_get_hostname_from_ip"
    "test_pywhois_get_hostname_from_ip"
    "test_pywhois_aio_lookup_ipv4"
    "test_not_found"
    "test_aio_from_whois_cmd"
    "test_aio_get_hostname_from_ip"
    "test_from_whois_cmd"
    "test_get_hostname_from_ip"
    "test_whois_query_run"
  ];

  pythonImportsCheck = [ "asyncwhois" ];

  meta = with lib; {
    description = "Python module for retrieving WHOIS information";
    homepage = "https://github.com/pogzyb/asyncwhois";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
