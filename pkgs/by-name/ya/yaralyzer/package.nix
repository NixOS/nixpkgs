{
  lib,
  python3,
  fetchFromGitHub,
  gitUpdater,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "yaralyzer";
  version = "1.3.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "michelcrypt4d4mus";
    repo = "yaralyzer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OhZ1TG1dqxlUoW+OI+BFn0LsujLytqg6L7aNdYnfRPQ=";
  };

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    chardet
    python-dotenv
    rich
    rich-argparse-plus
    yara-python
  ];

  pythonImportsCheck = [ "yaralyzer" ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Tool to visually inspect and force decode YARA and regex matches";
    homepage = "https://github.com/michelcrypt4d4mus/yaralyzer";
    changelog = "https://github.com/michelcrypt4d4mus/yaralyzer/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "yaralyze";
  };
})
