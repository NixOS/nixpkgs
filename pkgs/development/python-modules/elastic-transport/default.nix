{ lib
, aiohttp
, buildPythonPackage
, certifi
, fetchFromGitHub
, mock
, pytest-asyncio
, pytest-httpserver
, pytestCheckHook
, pythonOlder
, requests
, trustme
, urllib3
}:

buildPythonPackage rec {
  pname = "elastic-transport";
  version = "8.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "elastic-transport-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-rZdl2gjY5Yg2Ls777tj12pPATMn//xVvEM4wkrZ3qUY=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov-report=term-missing --cov=elastic_transport" ""
  '';

  propagatedBuildInputs = [
    urllib3
    certifi
  ];

  nativeCheckInputs = [
    aiohttp
    mock
    pytest-asyncio
    pytest-httpserver
    pytestCheckHook
    requests
    trustme
  ];

  pythonImportsCheck = [
    "elastic_transport"
  ];

  disabledTests = [
    # Tests require network access
    "fingerprint"
    "ssl"
    "test_custom_headers"
    "test_custom_user_agent"
    "test_default_headers"
    "test_head"
    "tls"
  ];

  meta = with lib; {
    description = "Transport classes and utilities shared among Python Elastic client libraries";
    homepage = "https://github.com/elasticsearch/elastic-transport-python";
    changelog = "https://github.com/elastic/elastic-transport-python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
