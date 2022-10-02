{ lib
, asynctest
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, python-socks
, pythonOlder
, tldextract
, whodap
}:

buildPythonPackage rec {
  pname = "asyncwhois";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pogzyb";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TpUiUW9ntrpuT/rUhucedl+DM5X88Mislrd+3D5/TUE=";
  };

  propagatedBuildInputs = [
    python-socks
    tldextract
    whodap
  ];

  checkInputs = [
    asynctest
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
  ];

  pythonImportsCheck = [
    "asyncwhois"
  ];

  meta = with lib; {
    description = "Python module for retrieving WHOIS information";
    homepage = "https://github.com/pogzyb/asyncwhois";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
