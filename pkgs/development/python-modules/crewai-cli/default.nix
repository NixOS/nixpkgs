{
  lib,
  buildPythonPackage,

  # build-system
  hatchling,

  # dependencies
  appdirs,
  certifi,
  click,
  crewai-core,
  cryptography,
  httpx,
  packaging,
  pydantic,
  pydantic-settings,
  pyjwt,
  python-dotenv,
  rich,
  textual,
  tomli,
  tomli-w,
  uv,

  # tests
  versionCheckHook,

  # passthru
  aiohttp,
  crewai,
  pytest-asyncio,
  pytest-recording,
  pytest-subprocess,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  vcrpy,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "crewai-cli";
  version = "1.15.18";
  pyproject = true;
  __structuredAttrs = true;

  inherit (crewai-core) src;

  sourceRoot = "${finalAttrs.src.name}/lib/cli";

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "click"
    "crewai-core"
    "pydantic"
    "pydantic-settings"
    "pyjwt"
    "python-dotenv"
    "textual"
    "tomli"
    "tomli-w"
    "uv"
  ];
  dependencies = [
    appdirs
    certifi
    click
    crewai-core
    cryptography
    httpx
    packaging
    pydantic
    pydantic-settings
    pyjwt
    python-dotenv
    rich
    textual
    tomli
    tomli-w
    uv
  ];

  pythonImportsCheck = [ "crewai_cli" ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  disabledTests = [
    # error: Failed to discover managed Python installations
    # Caused by: Could not read ELF interpreter from any of the following paths: /bin/sh, /usr/bin/env, /bin/dash, /bin/ls
    "test_create_crew"
    "test_deploy_with_project_name"
    "test_deploy_with_remote_keeps_remote_path_when_fetch_fails"
    "test_deploy_with_remote_keeps_remote_path_when_initial_commit_fails"
    "test_deploy_with_uuid"
    "test_json_runner_code_loads_current_cli_package_over_project_env"
    "test_json_runner_imports_with_older_project_env_crewai_core"
    "test_missing_crewai_package_shows_full_install_hint"
    "test_publish_calls_api"
    "test_publish_metadata_extraction_failure_continues_with_warning"

    # ValueError: Git fetch failed with exit code
    "test_publish_api_error"
    "test_publish_failure"

    # AssertionError: assert '"crewai[tools]>=1.15.0,<2.0.0"' in content
    "test_create_success"
  ];

  # Circular dependency with crewai
  passthru.tests = finalAttrs.finalPackage.overrideAttrs (old: {
    nativeInstallCheckInputs = [
      aiohttp
      crewai
      pytest-asyncio
      pytest-recording
      pytest-subprocess
      pytest-timeout
      pytest-xdist
      pytestCheckHook
      vcrpy
      writableTmpDirAsHomeHook
    ];
  });

  meta = {
    description = "CLI for CrewAI: scaffold, run, deploy and manage AI agent crews";
    homepage = "https://github.com/crewAIInc/crewAI/tree/main/lib/cli";
    changelog = "https://github.com/crewAIInc/crewAI/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "crewai";
  };
})
