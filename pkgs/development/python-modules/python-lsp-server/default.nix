{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools-scm,

  # dependencies
  docstring-to-markdown,
  jedi,
  pluggy,
  python-lsp-jsonrpc,
  setuptools,
  ujson,
  importlib-metadata,

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

  # checks
  flaky,
  matplotlib,
  numpy,
  pandas,
  pytestCheckHook,
  websockets,

  testers,
  python-lsp-server,
}:

buildPythonPackage rec {
  pname = "python-lsp-server";
  version = "1.12.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "python-lsp-server";
    rev = "refs/tags/v${version}";
    hash = "sha256-oFqa7DtFpJmDZrw+GJqrFH3QqnMAu9159q3IWT9vRko=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov-report html --cov-report term --junitxml=pytest.xml" "" \
      --replace-fail "--cov pylsp --cov test" ""
  '';

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
    docstring-to-markdown
    jedi
    pluggy
    python-lsp-jsonrpc
    setuptools # `pkg_resources`imported in pylsp/config/config.py
    ujson
  ] ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

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
    pytestCheckHook
  ] ++ optional-dependencies.all;

  disabledTests = [
    # Don't run lint tests
    "test_pydocstyle"
    # https://github.com/python-lsp/python-lsp-server/issues/243
    # "test_numpy_completions"
    "test_workspace_loads_pycodestyle_config"
    "test_autoimport_code_actions_and_completions_for_notebook_document"
    # avoid dependencies on many Qt things just to run one singular test
    "test_pyqt_completion"
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [
    "pylsp"
    "pylsp.python_lsp"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = python-lsp-server;
      version = "v${version}";
    };
  };

  meta = {
    description = "Python implementation of the Language Server Protocol";
    homepage = "https://github.com/python-lsp/python-lsp-server";
    changelog = "https://github.com/python-lsp/python-lsp-server/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pylsp";
  };
}
