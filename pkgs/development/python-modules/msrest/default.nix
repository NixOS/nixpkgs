{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  setuptools,

  # dependencies
  aiodns,
  aiohttp,
  azure-core,
  certifi,
  isodate,
  requests,
  requests-oauthlib,

  # tests
  pytestCheckHook,
  pytest-aiohttp,
  httpretty,
  trio,
}:

buildPythonPackage {
  pname = "msrest";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "msrest-for-python";
    # no tag for 0.7.1 see:
    # https://github.com/Azure/msrest-for-python/issues/254
    rev = "2d8fd04f68a124d0f3df7b81584accc3270b1afc";
    hash = "sha256-1EXXXflhDeU+erdI+NsWxSX76ooDTl3+MyQwRzm2xV0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiodns
    aiohttp
    azure-core
    certifi
    isodate
    requests
    requests-oauthlib
  ];

  nativeCheckInputs = [
    httpretty
    pytest-aiohttp
    pytestCheckHook
    trio
  ];

  disabledTests = [
    # Test require network access
    "test_basic_aiohttp"
    "test_basic_aiohttp"
    "test_basic_async_requests"
    "test_basic_async_requests"
    "test_conf_async_requests"
    "test_conf_async_requests"
    "test_conf_async_trio_requests"
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [
    # See https://github.com/Azure/msrest-for-python/issues/261
    # Upstream ignores the following patch that should fix it:
    # https://github.com/Azure/msrest-for-python/pull/262
    # And it doesn't apply anymore.
    "test_apikey_auth"
    "test_cs_auth"
    "test_eventgrid_auth"
    "test_eventgrid_domain_auth"
  ];

  disabledTestPaths = [
    # 2 AssertionErrors... See:
    # https://github.com/Azure/msrest-for-python/issues/267
    "tests/asynctests/test_async_client.py::TestServiceClient::test_client_send"
    "tests/test_client.py::TestServiceClient::test_client_send"
  ];

  pythonImportsCheck = [ "msrest" ];

  meta = {
    description = "Runtime library for AutoRest generated Python clients";
    homepage = "https://github.com/Azure/msrest-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bendlas
      maxwilson
    ];
  };
}
