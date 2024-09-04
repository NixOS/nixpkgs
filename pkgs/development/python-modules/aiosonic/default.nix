{
  nodejs,
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  # install_requires
  charset-normalizer,
  h2,
  onecache,
  # test dependencies
  asgiref,
  black,
  django,
  click,
  httpx,
  proxy-py,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-django,
  pytest-mock,
  pytest-sugar,
  pytest-timeout,
  uvicorn,
  httptools,
  typed-ast,
  uvloop,
  requests,
  aiohttp,
  aiodns,
  pytestCheckHook,
  stdenv,
}:

buildPythonPackage rec {
  pname = "aiosonic";
  version = "0.21.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "sonic182";
    repo = "aiosonic";
    rev = "refs/tags/${version}";
    hash = "sha256-YvqRuxl+Dgnsla/iotvWREdh93jwnXaq+F9py9MGP0o=";
  };

  postPatch = ''
    substituteInPlace pytest.ini --replace-fail \
      "addopts = --black --cov=aiosonic --cov-report term --cov-report html --doctest-modules" \
      "addopts = --doctest-modules"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    charset-normalizer
    onecache
    h2
  ];

  nativeCheckInputs = [
    aiohttp
    aiodns
    asgiref
    black
    django
    click
    httpx
    proxy-py
    pytest-aiohttp
    pytest-asyncio
    pytest-django
    pytest-mock
    pytest-sugar
    pytest-timeout
    uvicorn
    httptools
    typed-ast
    uvloop
    requests
    pytestCheckHook
    nodejs
  ];

  pythonImportsCheck = [ "aiosonic" ];

  disabledTests =
    lib.optionals stdenv.isLinux [
      # need network
      "test_simple_get"
      "test_get_python"
      "test_post_http2"
      "test_get_http2"
      "test_method_lower"
      "test_keep_alive_smart_pool"
      "test_keep_alive_cyclic_pool"
      "test_get_with_params"
      "test_get_with_params_in_url"
      "test_get_with_params_tuple"
      "test_post_form_urlencoded"
      "test_post_tuple_form_urlencoded"
      "test_post_json"
      "test_put_patch"
      "test_delete"
      "test_delete_2"
      "test_get_keepalive"
      "test_post_multipart_to_django"
      "test_connect_timeout"
      "test_read_timeout"
      "test_timeouts_overriden"
      "test_pool_acquire_timeout"
      "test_simple_get_ssl"
      "test_simple_get_ssl_ctx"
      "test_simple_get_ssl_no_valid"
      "test_get_chunked_response"
      "test_get_chunked_response_and_not_read_it"
      "test_read_chunks_by_text_method"
      "test_get_body_gzip"
      "test_get_body_deflate"
      "test_post_chunked"
      "test_close_connection"
      "test_close_old_keeped_conn"
      "test_get_redirect"
      "test_max_redirects"
      "test_get_image"
      "test_get_image_chunked"
      "test_get_with_cookies"
      "test_proxy_request"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # "FAILED tests/test_proxy.py::test_proxy_request - Exception: port 8865 never got active"
      "test_proxy_request"
    ];

  meta = {
    changelog = "https://github.com/sonic182/aiosonic/blob/${version}/CHANGELOG.md";
    description = "Very fast Python asyncio http client";
    license = lib.licenses.mit;
    homepage = "https://github.com/sonic182/aiosonic";
    maintainers = with lib.maintainers; [ geraldog ];
  };
}
