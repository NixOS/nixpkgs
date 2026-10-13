{
  lib,
  stdenv,
  aiodns,
  buildPythonPackage,
  charset-normalizer,
  fetchFromGitHub,
  h2,
  onecache,
  pkgs,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiosonic";
  version = "1.3.2";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "sonic182";
    repo = "aiosonic";
    tag = finalAttrs.version;
    hash = "sha256-nCCQBcbIWQ+FAKLXX6IRuFWGjQUXuSqzwGN2A9jfVdw=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "h2" ];

  dependencies = [
    charset-normalizer
    h2
    onecache
  ];

  nativeCheckInputs = [
    aiodns
    pkgs.nodejs
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiosonic" ];

  disabledTests =
    lib.optionals stdenv.hostPlatform.isLinux [
      # getaddrinfo with AI_ADDRCONFIG fails for every host, even 127.0.0.1, when only
      # loopback is up, https://github.com/sonic182/aiosonic/issues/644
      "test_aclose_with_unread_stream_does_not_hang"
      "test_async_with_closes_only_its_own_connector"
      "test_auths_by_host"
      "test_close_connection"
      "test_close_old_keeped_conn"
      "test_connect_timeout"
      "test_default_headers_and_params"
      "test_defaults_merge_and_sync_body"
      "test_delete"
      "test_delete_2"
      "test_event_hooks"
      "test_get_body_deflate"
      "test_get_body_gzip"
      "test_get_chunked_response"
      "test_get_chunked_response_and_not_read_it"
      "test_get_http2"
      "test_get_image"
      "test_get_image_stream_h2"
      "test_get_keepalive"
      "test_get_python"
      "test_get_redirect"
      "test_get_with_cookies"
      "test_get_with_params"
      "test_get_with_params_in_url"
      "test_get_with_params_tuple"
      "test_get_without_dns_cache_resolves_every_new_connection"
      "test_h2_client_level_flag"
      "test_h2_closing_client_fails_pending_stream_instead_of_hanging"
      "test_h2_connection_reused_across_requests"
      "test_h2_custom_config_reaches_live_connection"
      "test_h2_custom_ssl_ctx_gets_alpn"
      "test_h2_flow_control_large_body"
      "test_h2_multiplexing_concurrent_requests"
      "test_h2_stream_aclose_releases_slot"
      "test_h2_stream_reset_leaves_client_usable"
      "test_h2_verify_false_applies_to_h2_ssl_context"
      "test_h2_with_explicit_http2_flag"
      "test_head_and_options"
      "test_hooks_url_and_response_hook_error"
      "test_iter_lines"
      "test_keep_alive_cyclic_pool"
      "test_keep_alive_smart_pool"
      "test_keepalive_reuse_respects_connection_lifecycle"
      "test_legacy_multipart_uses_cryptographic_boundary"
      "test_max_conn_idle_ms"
      "test_max_redirects"
      "test_method_lower"
      "test_multipart_backward_compatibility"
      "test_patch_method"
      "test_pool_acquire_timeout"
      "test_post_chunked"
      "test_post_form_urlencoded"
      "test_post_http2"
      "test_post_json"
      "test_post_method"
      "test_post_multipart"
      "test_post_multipart_with_class"
      "test_post_multipart_with_metadata"
      "test_post_multipart_with_multipartfile_class"
      "test_post_multipart_with_multipartfile_path"
      "test_post_see_other_redirect_is_sent_as_get_without_body"
      "test_post_tuple_form_urlencoded"
      "test_put_method"
      "test_put_patch"
      "test_raise_for_status"
      "test_read_chunks_by_text_method"
      "test_read_timeout"
      "test_request_bodies"
      "test_request_headers_and_query_on_wire"
      "test_response_history_and_elapsed"
      "test_response_in_use_survives_client_close"
      "test_retries_exhausted_on_stale_connections"
      "test_retry_on_dropped_connection"
      "test_secure_cookies_stay_on_https"
      "test_simple_get_ssl"
      "test_simple_get_ssl_ctx"
      "test_simple_get_ssl_no_valid"
      "test_status_errors_and_redirects"
      "test_stream_close_of_bodyless_response_keeps_other_request_connection"
      "test_stream_content_length_body"
      "test_stream_early_exit_frees_pool"
      "test_stream_follow_redirect_releases_connections"
      "test_stream_partial_read_without_aclose_discards_connection"
      "test_stream_request_body_h2"
      "test_timeout_limits_waiting_for_pool"
      "test_timeouts_overriden"
      "test_wrapper_delete_http_serv"
      "test_wrapper_get_http_serv"
    ]
    ++ [
      # need a proxy-py server, which does not start in the sandbox
      "test_proxy_request"
      "test_proxy_url_credentials"
      "test_trust_env_proxy"
    ];

  disabledTestPaths = [
    # needs the ws npm package, and the rest hit issue 644
    "tests/test_aiosonic_ws.py"
    # tests hang
    "tests/test_sse.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # https://github.com/sonic182/aiosonic/issues/644
    "tests/test_aiosonic.py::test_simple_get"
    "tests/test_httpx_client.py::test_stream"
  ];

  meta = {
    description = "Python asyncio http client";
    homepage = "https://github.com/sonic182/aiosonic";
    changelog = "https://github.com/sonic182/aiosonic/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ geraldog ];
  };
})
