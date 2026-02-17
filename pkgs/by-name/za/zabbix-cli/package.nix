{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  python3Packages,
  testers,
  zabbix-cli,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "zabbix-cli";
  version = "3.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unioslo";
    repo = "zabbix-cli";
    tag = finalAttrs.version;
    hash = "sha256-Y4IR/le+7X3MYmrVnZMr+Gu59LkCB5UfMJ2s9ovSjLM=";
  };

  patches = [
    # Fix MarkupMode import with Typer >= 0.20.1
    # https://github.com/unioslo/zabbix-cli/pull/333
    (fetchpatch {
      url = "https://github.com/unioslo/zabbix-cli/commit/b68f672f557ccb06fef3fd5a2d724633f1eb3c68.patch";
      hash = "sha256-wc59c28aT8IsI4nvEH+CxfdvPAsN2R1uoLgN8tx+mBE=";
    })
  ];

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

  disabledTests = [
    # Disable failing test with Click >= v8.2.0
    "test_patch_get_click_type"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Requires network access
    "test_authenticator_login_with_any"
    "test_client_auth_method"
    "test_client_logout"
    # PermissionError: [Errno 1] Operation not permitted: 'ps'
    "test_is_headless_map"
    "test_is_headless_set_false"
  ];

  pythonImportsCheck = [ "zabbix_cli" ];

  passthru.tests.version = testers.testVersion {
    package = zabbix-cli;
    command = "HOME=$(mktemp -d) zabbix-cli --version";
  };

  meta = {
    description = "Command-line interface for Zabbix";
    homepage = "https://github.com/unioslo/zabbix-cli";
    license = lib.licenses.gpl3Plus;
    mainProgram = "zabbix-cli";
    maintainers = [ lib.maintainers.anthonyroussel ];
  };
})
