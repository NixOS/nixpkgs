{
  lib,
<<<<<<< HEAD
  stdenv,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchFromGitHub,
  python3Packages,
  testers,
  zabbix-cli,
}:

python3Packages.buildPythonApplication rec {
  pname = "zabbix-cli";
<<<<<<< HEAD
  version = "3.6.2";
=======
  version = "3.5.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unioslo";
    repo = "zabbix-cli";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-Y4IR/le+7X3MYmrVnZMr+Gu59LkCB5UfMJ2s9ovSjLM=";
=======
    hash = "sha256-Fk3o0+cNCX/ixqNd9oldY6JJ+wQWlMjBAEwuAWCLURQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies =
    with python3Packages;
    [
      httpx
      httpx.optional-dependencies.socks
      packaging
      platformdirs
      prompt-toolkit
      pydantic
      requests
      rich
<<<<<<< HEAD
      shellingham
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      strenum
      tomli
      tomli-w
      typer
      typing-extensions
    ]
    ++ lib.optionals (pythonOlder "3.10") [
      importlib-metadata
    ];

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
<<<<<<< HEAD
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Requires network access
    "test_authenticator_login_with_any"
    "test_client_auth_method"
    "test_client_logout"
    # PermissionError: [Errno 1] Operation not permitted: 'ps'
    "test_is_headless_map"
    "test_is_headless_set_false"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
}
