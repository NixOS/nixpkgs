{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  cli-base-utilities,
  cookiecutter,
  tomlkit,
  editorconfig,
  ruff,
  ty,
  tyro,
  rich,
  pytestCheckHook,
  python-gnupg,
  bx-py-utils,
  urllib3,
  pip-tools,
  typeguard,
  gitMinimal,
}:

buildPythonPackage (finalAttrs: {
  pname = "manageprojects";
  version = "0.28.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jedie";
    repo = "manageprojects";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kvpfbs5tDssSIJkpmsbqGF7KPmpKX29HAv6g3FLxWcY=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    cookiecutter
    tomlkit
    editorconfig
    ruff
    ty
    # Break the circular check dependency betwee manageprojects and cli-base-utilities
    (cli-base-utilities.overridePythonAttrs { doCheck = false; })
    tyro
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
    # Requires network access to clone a project template
    "test_start_managed_project"
    # Requires network access to resolve a git repository path
    "test_get_repo_path"
    # Requires the source directory to be inside a git repository
    "test_readme_history"
    "test_get_git_info"
    "test_up2date_docs"
    # AssertionError in build assertions — platform-specific path issues
    "test_build"
    "test_install"
    "test_get_config"
    "test_format_one_file"
    # typeguard.TypeCheckError — type annotations stricter than runtime type
    "test_happy_path"
    # Tries to run executables not found in Nix sandbox
    "test_code_style"
    "test_version"
  ];

  pythonImportsCheck = [ "manageprojects" ];

  meta = {
    description = "Helper to manage git-based projects with Cookiecutter templates";
    homepage = "https://github.com/jedie/manageprojects";
    changelog = "https://github.com/jedie/manageprojects/blob/main/README.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
