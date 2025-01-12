{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  bx-py-utils,
  tomlkit,
  tyro,
  click,
  rich,
  rich-click,
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
  tox,
  gitMinimal,
}:

buildPythonPackage rec {
  pname = "cli-base-utilities";
  version = "0.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jedie";
    repo = "cli-base-utilities";
    rev = "refs/tags/v${version}";
    hash = "sha256-vCTqodXqYPyWNW3HR5m0op8+WoApXLb3c7WZlpirDyk=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    bx-py-utils
    tomlkit
    tyro
    click
    rich
    rich-click
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
    tox
    gitMinimal
  ];

  disabledTests = [
    "test_expand_user"
    # Requires access to /usr
    "test_service_control"
    # Requires source for this package to be a git repo, see below.
    "test_temp_content_file"
  ];

  disabledTestPaths = [
    # Require source of this package to have a .git folder(and thus be a git repo)
    # which makes fetching the package potentially non-reproducible.
    # Therefore these tests have to be disabled.
    "cli_base/cli_tools/tests/test_git.py"
    "cli_base/cli_tools/tests/test_git_history.py"
    "cli_base/tests/test_readme_history.py"
    "cli_base/tests/test_pre_commit.py"

    # Causes `getpwnam()` errors since it can't create new users in the sandbox.
    "cli_base/tests/test_readme.py"
    # Doesn't properly find the executables
    "cli_base/cli_tools/tests/test_code_style.py"
    "cli_base/cli_tools/tests/test_dev_tools.py"
    "cli_base/tests/test_project_setup.py"
    "cli_base/cli_tools/tests/test_mock_rich.py"
  ];

  pythonImportsCheck = [ "cli_base" ];

  meta = {
    description = "Helpers to build a CLI program";
    homepage = "https://github.com/jedie/cli-base-utilities";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
