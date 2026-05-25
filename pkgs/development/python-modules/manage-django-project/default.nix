{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  django-tools,
  cli-base-utilities,
  manageprojects,
  bx-py-utils,
  django-rich,
  cmd2,
  pytestCheckHook,
  pytest-django,
  cmd2-ext-test,
  typeguard,
  coverage,
}:

buildPythonPackage (finalAttrs: {
  pname = "manage-django-project";
  version = "0.12.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jedie";
    repo = "manage_django_project";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PeeKf0xC8yRrGpK5Q23A6ixl0sBxNOgXsef1cI3mlLE=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    django
    # Disable checks to avoid circular dependency... as django-tools depends on this package
    (django-tools.overridePythonAttrs { doCheck = false; })
    # Disable checks to avoid version conflicts from manageprojects' cli-base-utilities pin
    (cli-base-utilities.overridePythonAttrs { doCheck = false; })
    manageprojects
    bx-py-utils
    django-rich
    cmd2
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    cmd2-ext-test
    typeguard
    coverage
  ];

  env.DJANGO_SETTINGS_MODULE = "manage_django_project_example.settings.tests";

  disabledTests = [
    # Requires the source directory to be inside a git repository
    "test_readme_history"
    # Executables are located in different paths in the Nix sandbox than tests expect
    "test_basic_code_style"
    "test_basic_tox"
    "test_basic_update_req"
    "test_code_style"
    "test_happy_path"
    "test_manage_py_call"
    "test_project_info"
    "test_update_test_snapshot_files"
  ];

  pythonImportsCheck = [ "manage_django_project" ];

  meta = {
    description = "Helper to develop Django projects";
    homepage = "https://github.com/jedie/manage_django_project";
    changelog = "https://github.com/jedie/manage_django_project/blob/main/README.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
