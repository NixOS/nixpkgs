{
  lib,
  fetchFromGitHub,
  python3Packages,
  testers,
  zabbix-cli,
}:

python3Packages.buildPythonApplication rec {
  pname = "zabbix-cli";
  version = "3.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unioslo";
    repo = "zabbix-cli";
    tag = version;
    hash = "sha256-Sgt3kVbyzNJCSVUYErHNOrgc7Jd3tIwYhwOESRPeAyw=";
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
