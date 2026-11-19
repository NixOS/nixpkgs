{
  lib,
  stdenv,
  astroid,
  buildPythonPackage,
  dill,
  fetchFromGitHub,
  gitpython,
  isort,
  mccabe,
  platformdirs,
  py,
  pyprojectVersionPatchHook,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  pythonAtLeast,
  requests,
  setuptools,
  tomlkit,
  typing-extensions,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylint";
  version = "4.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pylint-dev";
    repo = "pylint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QM0+psWDnYyAfg9t1HJZmqMoZtiFHk5YchMeGowfNcw=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    astroid
    dill
    isort
    mccabe
    platformdirs
    tomlkit
  ];

  nativeCheckInputs = [
    gitpython
    # https://github.com/PyCQA/pylint/blob/main/requirements_test_min.txt
    py
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    requests
    typing-extensions
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    "tests/benchmark"
    # FIXME package pytest-remaster
    "tests/reporters/unittest_junit_reporter.py"
  ];

  disabledTests =
    lib.optionals (pythonAtLeast "3.14") [
      # ModuleNotFoundError: No module named 'completely_unknown'
      "test_do_not_import_files_from_local_directory"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "test_parallel_execution"
      "test_py3k_jobs_option"
    ];

  meta = {
    description = "Bug and style checker for Python";
    homepage = "https://pylint.readthedocs.io/en/stable/";
    changelog = "https://github.com/pylint-dev/pylint/releases/tag/${finalAttrs.src.tag}";
    longDescription = ''
      Pylint is a Python static code analysis tool which looks for programming errors,
      helps enforcing a coding standard, sniffs for code smells and offers simple
      refactoring suggestions.
      Pylint is shipped with following additional commands:
      - pyreverse: an UML diagram generator
      - symilar: an independent similarities checker
      - epylint: Emacs and Flymake compatible Pylint
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "pylint";
  };
})
