{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  cli-base-utilities,
  cookiecutter,
  tomlkit,
  editorconfig,
  darker,
  flynt,
  isort,
  pygments,
  autoflake,
  pyflakes,
  autopep8,
  flake8,
  flake8-bugbear,
  pyupgrade,
  refurb,
  codespell,
  mypy,
  click,
  rich-click,
  rich,
  pytestCheckHook,
  python-gnupg,
  bx-py-utils,
  urllib3,
  pip-tools,
  typeguard,
  gitMinimal,
}:

buildPythonPackage rec {
  pname = "manageprojects";
  version = "0.19.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jedie";
    repo = "manageprojects";
    rev = "refs/tags/v${version}";
    hash = "sha256-ghNx1QngHr9ZV1Y+lJpw6DLpfiUBF/2zRif84qcktCQ=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    cookiecutter
    tomlkit
    editorconfig
    darker
    flynt
    isort
    pygments
    autoflake
    pyflakes
    autopep8
    flake8
    flake8-bugbear
    pyupgrade
    refurb
    codespell
    mypy
    # Disabling checks prevents a dependency loop since these packages depend on eachother
    (cli-base-utilities.overridePythonAttrs { doCheck = false; })
    click
    rich-click
    rich
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    pytestCheckHook
    python-gnupg
    bx-py-utils
    urllib3
    pip-tools
    typeguard
    gitMinimal
  ];

  disabledTests = [
    # Require network access
    "test_start_managed_project"
    "test_get_repo_path"

    # Requires source to be a git dir, which isn't the case in Nix's build environment.
    "test_readme_history"
    "test_get_git_info"
    "test_up2date_docs"

    # AssertionError
    "test_build"
    "test_install"
    "test_get_config"
    "test_format_one_file"

    # typeguard.TypeCheckError
    "test_happy_path"

    # FileNotFoundError
    "test_code_style"
    "test_version"
  ];

  pythonImportsCheck = [ "manageprojects" ];

  meta = {
    description = "Helper to develop Django projects";
    homepage = "https://github.com/jedie/manage_django_project";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
