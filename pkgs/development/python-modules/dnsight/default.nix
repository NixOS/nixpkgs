{
  lib,
  stdenv,
  buildPythonPackage,
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
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dnsight";
    repo = "dnsight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WoYLAqNTbMVe+kd/cG1MPRSlYMMYPWP8wm96qr3IdY8=";
  };

  pythonRelaxDeps = [ "typer" ];

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
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
  ];

  meta = {
    description = "SDK and CLI tool for DNS, email and web security hygiene";
    homepage = "https://github.com/dnsight/dnsight";
    changelog = "https://github.com/dnsight/dnsight/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dnsight";
  };
})
