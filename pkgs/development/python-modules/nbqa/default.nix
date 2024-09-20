{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  setuptools,
  autoflake,
  autopep8,
  distutils,
  ipython,
  mdformat,
  pre-commit-hooks,
  pydocstyle,
  pytestCheckHook,
  tokenize-rt,
  tomli,
  yapf,
  # Optional Dependencies
  flake8,
  isort,
  jupytext,
  mypy,
  pylint,
  pyupgrade,
  black,
  blacken-docs,
  ruff,
}:

buildPythonPackage rec {
  pname = "nbqa";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nbQA-dev";
    repo = "nbQA";
    rev = "refs/tags/${version}";
    hash = "sha256-9s+q2unh+jezU0Er7ZH0tvgntmPFts9OmsgAMeQXRrY=";
  };

  build-system = [ setuptools ];

  passthru.optional-dependencies = {
    inherit
      black
      blacken-docs
      flake8
      isort
      jupytext
      mypy
      pylint
      pyupgrade
      ruff
      ;
  };

  dependencies = [
    autopep8
    ipython
    tokenize-rt
    tomli
  ] ++ builtins.attrValues passthru.optional-dependencies;

  postPatch = ''
    # Force using the Ruff executable rather than the Python package
    substituteInPlace nbqa/__main__.py --replace 'if shell:' 'if shell or main_command == "ruff":'
  '';

  preCheck = ''
    # Allow the tests to run `nbqa` itself from the path
    export PATH="$out/bin":"$PATH"
  '';

  nativeCheckInputs = [
    black
    ruff
    autoflake
    distutils
    flake8
    isort
    jupytext
    mdformat
    pre-commit-hooks
    pydocstyle
    pylint
    pytestCheckHook
    pyupgrade
    yapf
  ];

  disabledTests = [
    # Test data not found
    "test_black_multiple_files"
    "test_black_return_code"
    "test_grep"
    "test_jupytext_on_folder"
    "test_mypy_works"
    "test_running_in_different_dir_works"
    "test_unable_to_reconstruct_message_pythonpath"
    "test_with_subcommand"
    "test_pylint_works"
  ];

  disabledTestPaths = [
    # Test data not found
    "tests/test_include_exclude.py"
  ];

  passthru.tests = callPackage ./tests.nix { };

  meta = {
    homepage = "https://github.com/nbQA-dev/nbQA";
    changelog = "https://nbqa.readthedocs.io/en/latest/history.html";
    description = "Run ruff, isort, pyupgrade, mypy, pylint, flake8, black, blacken-docs, and more on Jupyter Notebooks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ l0b0 ];
    mainProgram = "nbqa";
  };
}
