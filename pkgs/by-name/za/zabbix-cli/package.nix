{
  lib,
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    # Force-load rich_utils, because typer lazily loads it since v0.17.0.
    # https://github.com/unioslo/zabbix-cli/pull/312
    (fetchpatch2 {
      name = "force-load-rich_utils.patch";
      url = "https://github.com/unioslo/zabbix-cli/commit/5e70cbcced216dde9fbcc6e3c1eb11a128d6ca54.patch";
      hash = "sha256-EX93OU7D1vIC0mv8QQuZWKgrwVBHStqvy+RMSFKUB/E=";
    })
  ];

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
