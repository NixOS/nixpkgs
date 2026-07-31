{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "zabbix-cli";
  version = "3.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unioslo";
    repo = "zabbix-cli";
    tag = finalAttrs.version;
    hash = "sha256-pI6UEI8Jx481rS/cTGBsQCtOGB+vMC1epYO8Pqkn4K0=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies =
    with python3Packages;
    [
      httpx
      packaging
      platformdirs
      prompt-toolkit
      pydantic
      requests
      rich
      shellingham
      strenum
      tomli
      tomli-w
      typer
      typing-extensions
    ]
    ++ httpx.optional-dependencies.socks;

  nativeCheckInputs = with python3Packages; [
    freezegun
    inline-snapshot
    pytestCheckHook
    pytest-httpserver
  ];

  # Otherwise tests will fail to create directory
  # Permission denied: '/homeless-shelter'
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # Requires network access
    "test_authenticator_login_with_any"
    "test_client_auth_method"
    "test_client_logout"
    # PermissionError: [Errno 1] Operation not permitted: 'ps'
    "test_is_headless_map"
    "test_is_headless_set_false"
  ];

  pythonImportsCheck = [ "zabbix_cli" ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  meta = {
    description = "Command-line interface for Zabbix";
    homepage = "https://github.com/unioslo/zabbix-cli";
    changelog = "https://github.com/unioslo/zabbix-cli/blob/${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.gpl3Plus;
    mainProgram = "zabbix-cli";
    maintainers = [ lib.maintainers.anthonyroussel ];
  };
})
