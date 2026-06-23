{
  aiohttp,
  buildPythonPackage,
  ddt,
  fetchFromGitHub,
  hatchling,
  lib,
  multidict,
  pytest-asyncio,
  pytestCheckHook,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiointercept";
  version = "0.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Polandia94";
    repo = "aiointercept";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+tl3Cb2Lkl40FdPNs5byCNoyfm9g6wEKtR0nT1jjrx0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    multidict
    yarl
  ];

  pythonImportsCheck = [
    "aiointercept"
    "aiointercept.pytest_plugin"
  ];

  nativeCheckInputs = [
    ddt
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # different indentation
    "test_assert_called_with_json"
    "test_assert_called_with_data_bytes"
    "test_assert_called_with_data_dict"
    "test_assert_called_with_strict_headers_fail"
    # connect to DNS servers
    "test_address_as_instance_of_url_combined_with_pass_through"
    "test_pass_through_unmatched_requests"
    "test_pass_through_with_origin_params"
    "test_passthrough_host_is_allowed"
    "test_passthrough_https_explicit"
    "test_passthrough_unmatched_allows_real_requests"
    "test_passthrough_unmatched_https_no_patterns"
    "test_passthrough_unmatched_https_with_patterns"
    "test_passthrough_unmatched_url_handler_unknown_path_proxied"
    "test_passthrough_unmatched_with_pattern_proxies_unmatched"
    "test_real_request_then_mock_same_host_ignores_stale_dns"
    "test_shared_resolve_no_active_instances_uses_real_resolver"
  ];

  meta = {
    changelog = "https://github.com/Polandia94/aiointercept/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Aiohttp mock library that routes requests through a real test server";
    homepage = "https://github.com/Polandia94/aiointercept";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
