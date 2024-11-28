{
  lib,
  fetchFromGitHub,
  python3Packages,
  testers,
  zabbix-cli,
}:

python3Packages.buildPythonApplication rec {
  pname = "zabbix-cli";
  version = "3.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "usit-gd";
    repo = "zabbix-cli";
    rev = "refs/tags/${version}";
    hash = "sha256-hvLtc6owEOD29Y1oC7EmOOFp9P8hWOuj9N7qhtqkpks=";
  };

  pythonRelaxDeps = [ "click-repl" ];

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies =
    with python3Packages;
    [
      click-repl
      httpx
      httpx.optional-dependencies.socks
      packaging
      platformdirs
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

  meta = with lib; {
    description = "Command-line interface for Zabbix";
    homepage = "https://github.com/unioslo/zabbix-cli";
    license = licenses.gpl3Plus;
    mainProgram = "zabbix-cli";
    maintainers = [ maintainers.anthonyroussel ];
  };
}
