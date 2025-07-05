{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "yaralyzer";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "michelcrypt4d4mus";
    repo = "yaralyzer";
    tag = "v${version}";
    hash = "sha256-HrYO7Fz9aLabx7nsilo/b/xe6OOzIq0P2PzVFtAPNEU=";
  };

  pythonRelaxDeps = [
    "python-dotenv"
    "rich"
  ];

  build-system = with python3.pkgs; [
    poetry-core
  ];

  dependencies = with python3.pkgs; [
    chardet
    python-dotenv
    rich
    rich-argparse-plus
    yara-python
  ];

  pythonImportsCheck = [
    "yaralyzer"
  ];

  meta = {
    description = "Tool to visually inspect and force decode YARA and regex matches";
    homepage = "https://github.com/michelcrypt4d4mus/yaralyzer";
    changelog = "https://github.com/michelcrypt4d4mus/yaralyzer/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "yaralyze";
  };
}
