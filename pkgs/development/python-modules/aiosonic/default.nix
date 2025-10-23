{
  lib,
  stdenv,
  aiohttp,
  buildPythonPackage,
  charset-normalizer,
  fetchFromGitHub,
  h2,
  httpx,
  onecache,
  pkgs,
  poetry-core,
  pytest-aiohttp,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  requests,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "aiosonic";
  version = "0.26.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "sonic182";
    repo = "aiosonic";
    tag = version;
    hash = "sha256-sYd7qjOiRENO6hPhJ01RLsr+2RtTITrXjcT6/ZaGfAU=";
  };

  postPatch = ''
    substituteInPlace pytest.ini --replace-fail \
      "addopts = --black " \
      "addopts = "
  '';

  build-system = [ poetry-core ];

  dependencies = [
    charset-normalizer
    h2
    onecache
  ];

  nativeCheckInputs = [
    aiohttp
    httpx
    pkgs.nodejs
    pytest-aiohttp
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    requests
    uvicorn
  ];

  pythonImportsCheck = [ "aiosonic" ];

  disabledTests =
    lib.optionals stdenv.hostPlatform.isLinux [
      # Tests require network access
      "test_close_connection"
      "test_close_old_keeped_conn"
      "test_connect_timeout"
      "test_delete_2"
      "test_delete"
      "test_get_body_deflate"
      "test_get_body_gzip"
      "test_get_chunked_response_and_not_read_it"
      "test_get_chunked_response"
      "test_get_http2"
      "test_get_image_chunked"
      "test_get_image"
      "test_get_keepalive"
      "test_get_python"
      "test_get_redirect"
      "test_get_with_cookies"
      "test_get_with_params_in_url"
      "test_get_with_params_tuple"
      "test_get_with_params"
      "test_keep_alive_cyclic_pool"
      "test_keep_alive_smart_pool"
      "test_max_conn_idle_ms"
      "test_max_redirects"
      "test_method_lower"
      "test_multipart_backward_compatibility"
      "test_pool_acquire_timeout"
      "test_post_chunked"
      "test_post_form_urlencoded"
      "test_post_http2"
      "test_post_json"
      "test_post_multipart_with_class"
      "test_post_multipart_with_metadata"
      "test_post_multipart_with_multipartfile_class"
      "test_post_multipart_with_multipartfile_path"
      "test_post_multipart"
      "test_post_tuple_form_urlencoded"
      "test_put_patch"
      "test_read_chunks_by_text_method"
      "test_read_timeout"
      "test_simple_get"
      "test_timeouts_overriden"
      "test_wrapper_delete_http_serv"
      "test_wrapper_get_http_serv"
      # Tests can't trigger server
      "test_ws"
      # Test requires proxy
      "test_proxy_request"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # "FAILED tests/test_proxy.py::test_proxy_request - Exception: port 8865 never got active"
      "test_proxy_request"
    ];

  meta = {
    changelog = "https://github.com/sonic182/aiosonic/blob/${src.tag}/CHANGELOG.md";
    description = "Very fast Python asyncio http client";
    license = lib.licenses.mit;
    homepage = "https://github.com/sonic182/aiosonic";
    maintainers = with lib.maintainers; [ geraldog ];
  };
}
