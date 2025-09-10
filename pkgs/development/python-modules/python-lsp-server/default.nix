{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  black,
  docstring-to-markdown,
  jedi,
  pluggy,
  python-lsp-jsonrpc,
  setuptools,
  ujson,

  # optional-dependencies
  autopep8,
  flake8,
  mccabe,
  pycodestyle,
  pydocstyle,
  pyflakes,
  pylint,
  rope,
  toml,
  whatthepatch,
  yapf,

  # tests
  flaky,
  matplotlib,
  numpy,
  pandas,
  pytest-cov-stub,
  pytestCheckHook,
  websockets,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "python-lsp-server";
  version = "1.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "python-lsp-server";
    tag = "v${version}";
    hash = "sha256-wxouTbqkieH3fxnXY0PIKDtDV97AbGWujisS2JmjBkE=";
  };

  pythonRelaxDeps = [
    "autopep8"
    "flake8"
    "mccabe"
    "pycodestyle"
    "pydocstyle"
    "pyflakes"
  ];

  build-system = [ setuptools-scm ];

  dependencies = [
    black
    docstring-to-markdown
    jedi
    pluggy
    python-lsp-jsonrpc
    setuptools # `pkg_resources`imported in pylsp/config/config.py
    ujson
  ];

  optional-dependencies = {
    all = [
      autopep8
      flake8
      mccabe
      pycodestyle
      pydocstyle
      pyflakes
      pylint
      rope
      toml
      websockets
      whatthepatch
      yapf
    ];
    autopep8 = [ autopep8 ];
    flake8 = [ flake8 ];
    mccabe = [ mccabe ];
    pycodestyle = [ pycodestyle ];
    pydocstyle = [ pydocstyle ];
    pyflakes = [ pyflakes ];
    pylint = [ pylint ];
    rope = [ rope ];
    yapf = [
      whatthepatch
      yapf
    ];
    websockets = [ websockets ];
  };

  nativeCheckInputs = [
    flaky
    matplotlib
    numpy
    pandas
    pytest-cov-stub
    pytestCheckHook
    versionCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ optional-dependencies.all;
  versionCheckProgram = "${placeholder "out"}/bin/pylsp";
  versionCheckProgramArg = "--version";

  disabledTests = [
    # avoid dependencies on many Qt things just to run one singular test
    "test_pyqt_completion"

    # Flaky: ValueError: I/O operation on closed file
    "test_concurrent_ws_requests"

    # AttributeError: 'NoneType' object has no attribute 'plugin_manager'
    "test_missing_message"
  ];

  pythonImportsCheck = [
    "pylsp"
    "pylsp.python_lsp"
  ];

  meta = {
    description = "Python implementation of the Language Server Protocol";
    homepage = "https://github.com/python-lsp/python-lsp-server";
    changelog = "https://github.com/python-lsp/python-lsp-server/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pylsp";
  };
}
