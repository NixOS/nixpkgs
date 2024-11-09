{
  python,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
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
  pip,
  pip-tools,
  coverage,
  tox,
  darker,
  flake8,
  pip-audit,
}:

buildPythonPackage rec {
  pname = "manage-django-project";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jedie";
    repo = "manage_django_project";
    rev = "refs/tags/v${version}";
    hash = "sha256-HkosxxFsX5juqKqwbF+2jTCsiKa1Y+zADFjxdlRBBVk=";
  };

  postPatch = ''
    substituteInPlace manage_django_project/tests/test_command_coverage.py \
    manage_django_project/tests/test_command_tox.py \
    manage_django_project/tests/test_command_update_test_snapshot_files.py \
      --replace-fail '.../bin/coverage' '${coverage}/bin/coverage'

    substituteInPlace manage_django_project/tests/test_command_install.py \
    manage_django_project/tests/test_command_update_req_basic_update_req_1.snapshot.json \
      --replace-fail '.../bin/pip' '${pip}/bin/pip'

    substituteInPlace manage_django_project/tests/test_command_safety.py \
      --replace-fail '.../bin/pip-audit' '${lib.getExe pip-audit}'

    substituteInPlace manage_django_project/tests/test_command_tox.py \
    manage_django_project/tests/test_command_update_test_snapshot_files.py \
      --replace-fail '.../bin/python' '${lib.getExe python}'

    substituteInPlace manage_django_project/tests/test_command_code_style.py \
      --replace-fail '.../bin/darker' '${lib.getExe darker}' \
      --replace-fail '.../bin/flake8' '${lib.getExe flake8}'

    substituteInPlace manage_django_project/tests/test_command_update_req.py \
      --replace-fail '.../bin/pip-sync' '${pip-tools}/bin/pip-sync'
  '';

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    django
    # Disable checks so that we don't dependency loop
    # Since django-tools depends on this package circularly
    # Do the same for cli-base-utilities so that we don't get dependency conflicts with cli-base-utilities from manageprojects
    (django-tools.overridePythonAttrs { doCheck = false; })
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
    pip
    pip-tools
    coverage
    tox
    darker
    flake8
    pip-audit
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE="manage_django_project_example.settings.tests"
  '';

  disabledTests = [
    # Requires source to be a git repo
    "test_readme_history"
    # Want called binaries to be in python's path, not the packages' path.
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
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
