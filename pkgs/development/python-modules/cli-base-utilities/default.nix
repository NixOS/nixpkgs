{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  bx-py-utils,
  tomlkit,
  tyro,
  rich,
  packaging,
  python-dateutil,
  pytestCheckHook,
  typeguard,
  urllib3,
  pre-commit,
  cfgv,
  identify,
  pyyaml,
  manageprojects,
  coverage,
  gitMinimal,
}:

buildPythonPackage (finalAttrs: {
  pname = "cli-base-utilities";
  version = "0.30.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jedie";
    repo = "cli-base-utilities";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GwpMGQBqOlTQgCHP2rCm6r8hW0pUJICP4Wjju4Eyi1U=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    bx-py-utils
    tomlkit
    tyro
    rich
    packaging
    python-dateutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
    urllib3
    typeguard
    pre-commit
    cfgv
    identify
    pyyaml
    manageprojects
    coverage
    gitMinimal
  ];

  disabledTests = [
    # Uses os.path.expanduser which resolves to a non-existent path in the Nix sandbox
    "test_expand_user"
    # Tries to call systemctl, not available in the build sandbox
    "test_service_control"
    # Reads a tempfile that gets resolved against the source tree git history
    "test_temp_content_file"
  ];

  disabledTestPaths = [
    # These tests require the source directory to be a git repo
    "cli_base/cli_tools/tests/test_git.py"
    "cli_base/cli_tools/tests/test_git_history.py"
    "cli_base/tests/test_readme_history.py"
    "cli_base/tests/test_pre_commit.py"
    # getpwnam() fails in the Nix sandbox because it cannot create new users
    "cli_base/tests/test_readme.py"
    # Executables are not in the expected paths inside the sandbox
    "cli_base/cli_tools/tests/test_code_style.py"
    "cli_base/cli_tools/tests/test_dev_tools.py"
    "cli_base/tests/test_project_setup.py"
    "cli_base/cli_tools/tests/test_mock_rich.py"
  ];

  pythonImportsCheck = [ "cli_base" ];

  meta = {
    description = "Helpers to build a CLI program";
    homepage = "https://github.com/jedie/cli-base-utilities";
    changelog = "https://github.com/jedie/cli-base-utilities/blob/main/README.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
