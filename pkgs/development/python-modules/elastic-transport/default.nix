{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub

# docs
, furo
, sphinx-autodoc-typehints
, sphinxHook

# propagates
, certifi
, urllib3

# tests
, aiohttp
, mock
, pytest-asyncio
, pytest-httpserver
, pytest-mock
, requests
, pytestCheckHook
, trustme
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
    sed -i '/addopts/d' setup.cfg
  '';

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    furo
    sphinx-autodoc-typehints
    sphinxHook
  ];

  sphinxRoot = "docs/sphinx";

  propgatedBuildInputs = [
    certifi
    urllib3
  ];

  checkInputs = [
    aiohttp
    mock
    pytest-asyncio
    pytest-httpserver
    pytest-mock
    pytestCheckHook
    requests
    trustme
  ];

  disabledTests = [
    # network access
    "test_unsupported_tls_versions"
    "test_supported_tls_versions"
    "test_assert_fingerprint_in_cert_chain"
    "test_assert_fingerprint_in_cert_chain_failure"
    "test_ssl_assert_fingerprint"
    "test_head"
    "test_custom_user_agent"
    "test_custom_headers"
    "test_default_headers"
  ];

  meta = with lib; {
    changelog = "https://github.com/elastic/elastic-transport-python/releases/tag/v${version}";
    description = "Transport classes and utilities shared among Python Elastic client libraries";
    homepage = "https://github.com/elastic/elastic-transport-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
