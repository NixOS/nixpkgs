{
  lib,
  stdenv,
  buildPythonPackage,
  click,
  cryptography,
  dnspython,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  httpx,
  hypothesis,
  iana-etc,
  libredirect,
  pydantic,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pyyaml,
  rich,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "dnsight";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dnsight";
    repo = "dnsight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TirYLziPa1xRm7D54Unl5oVjsnsv6Gl0LRVUXzd9o/E=";
  };

  pythonRelaxDeps = [
    "cryptography"
    "rich"
    "typer"
  ];

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    click
    cryptography
    dnspython
    httpx
    pydantic
    pyyaml
    rich
    typer
  ];

  nativeCheckInputs = [
    hypothesis
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dnsight" ];

  preCheck = lib.optionalString stdenv.hostPlatform.isLinux ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)
    export LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';

  postCheck = ''
    unset NIX_REDIRECTS LD_PRELOAD
  '';

  disabledTests = [
    # AssertionError
    "test_audit_explicit_domains_honour_global_config_path"
    "test_audit_manifest_runs_only_configured_checks"
    # AssertionError: assert (None is not None)
    "test_check_dmarc_async_config_slice_overrides_config"
    "test_check_dmarc_sync_config_slice_overrides_config"
    "test_check_spf_sync_with_mgr"
    "test_run_check_for_target_matches_run_zone"
    "test_run_check_sync_dmarc"
    "test_run_check_sync_programmatic_config_no_file"
    "test_run_check_sync_yaml_plus_overlay_merge"
    # CLI tests
    "test_caa_overlay_and_generate"
    "test_dmarc_check_with_overlay_and_generate_subcommand"
    "test_headers_check_overlay_and_generate_hsts_csp"
    "test_headers_generate_csp_invalid_json_exits_3"
    "test_main_writes_cli_index"
    "test_make_check_typer_dispatches_named_subcommand_before_variadic_domains"
    "test_mx_generate_invalid_rows_exits_3"
    "test_mx_overlay_and_generate"
    "test_spf_overlay_flatten_and_generate"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "SDK and CLI tool for DNS, email and web security hygiene";
    homepage = "https://github.com/dnsight/dnsight";
    changelog = "https://github.com/dnsight/dnsight/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dnsight";
  };
})
