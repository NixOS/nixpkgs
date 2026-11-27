{
  lib,
  anthropic,
  buildPythonPackage,
  certifi,
  click,
  fetchFromGitHub,
  google-generativeai,
  httpx,
  humanbound-firewall,
  mcp,
  nix-update-script,
  openai,
  pathspec,
  posthog,
  pydantic,
  pyperclip,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  pyyaml,
  requests,
  rich,
  scikit-learn,
  setuptools,
  starlette,
  torch,
  uvicorn,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "humanbound";
  version = "2.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "humanbound";
    repo = "humanbound";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EqoZfxHhIUFQcDGlA4rSx3vsChBZ8q09FgSHSdso0Vw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    certifi
    click
    httpx
    pathspec
    posthog
    pydantic
    pyperclip
    pyyaml
    requests
    rich
    starlette
    uvicorn
  ];

  optional-dependencies = {
    engine = [
      anthropic
      google-generativeai
      httpx
      openai
      websockets
    ];
    firewall = [
      humanbound-firewall
      scikit-learn
      torch
    ];
    mcp = [ mcp ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  disabledTests = [
    # Arena subcommands require Docker
    "test_help_exits_zero"
    "test_help_examples_work"
    "test_without_docker_on_path_fails_fast"
    "test_run_refused_by_the_container_baseline"
    "test_check_without_docker_exits_2"
    "test_serve_warns_on_non_loopback"
    "test_untrusted_agent_confirmation_shows_details"
    "test_pull_refuses_a_local_build_under_the_published_tag"
    "test_run_refuses_a_stale_published_tag"
    # Output format changes in 2.15.0
    "test_create_success"
    "test_no_auth_routes_to_local"
    "test_fire_and_return"
    "test_show_prints_model_info"
    "test_insights_section_says_insights_not_findings"
    "test_open_findings_labeled_as_project_level"
    "test_truncation_is_explicit"
    "test_points_to_full_report"
    "test_no_truncation_note_when_three_or_fewer"
    "test_logged_in_without_project_is_told_to_select_one"
    "test_upload_subcommand_is_reachable"
    "test_current_org"
    "test_subscription_features_and_quota_readable"
    "test_coverage_names_are_printed_as_text"
    "test_dimensions_and_findings_from_platform"
    "test_local_posture_says_no_project_selected"
    "test_current_shows_project_id"
    "test_non_arena_target_rejected"
  ];

  pythonImportsCheck = [ "humanbound" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source adversarial testing engine";
    homepage = "https://github.com/humanbound/humanbound";
    changelog = "https://github.com/humanbound/humanbound/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "hb";
    broken = lib.versionAtLeast mcp.version "2";
  };
})
