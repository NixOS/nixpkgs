{ lib
, stdenv
, autopep8
, buildPythonPackage
, docstring-to-markdown
, fetchFromGitHub
, flake8
, flaky
, importlib-metadata
, jedi
, matplotlib
, mccabe
, numpy
, pandas
, pluggy
, pycodestyle
, pydocstyle
, pyflakes
, pylint
, pyqt5
, pytestCheckHook
, python-lsp-jsonrpc
, pythonOlder
, pythonRelaxDepsHook
, rope
, setuptools
, setuptools-scm
, toml
, ujson
, websockets
, whatthepatch
, wheel
, yapf
}:

buildPythonPackage rec {
  pname = "python-lsp-server";
  version = "1.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dh33m7wgOwUETjdNqqDKZnpTgbrYCg9/XXC296tHm4w=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov-report html --cov-report term --junitxml=pytest.xml" "" \
      --replace "--cov pylsp --cov test" ""
  '';

  pythonRelaxDeps = [
    "autopep8"
    "flake8"
    "mccabe"
    "pycodestyle"
    "pydocstyle"
    "pyflakes"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    docstring-to-markdown
    jedi
    pluggy
    python-lsp-jsonrpc
    setuptools # `pkg_resources`imported in pylsp/config/config.py
    ujson
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  passthru.optional-dependencies = {
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
    autopep8 = [
      autopep8
    ];
    flake8 = [
      flake8
    ];
    mccabe = [
      mccabe
    ];
    pycodestyle = [
      pycodestyle
    ];
    pydocstyle = [
      pydocstyle
    ];
    pyflakes = [
      pyflakes
    ];
    pylint = [
      pylint
    ];
    rope = [
      rope
    ];
    yapf = [
      whatthepatch
      yapf
    ];
    websockets = [
      websockets
    ];
  };

  nativeCheckInputs = [
    flaky
    matplotlib
    numpy
    pandas
    pytestCheckHook
  ] ++ passthru.optional-dependencies.all
  # pyqt5 is broken on aarch64-darwin
  ++ lib.optionals (!stdenv.isDarwin || !stdenv.isAarch64) [
    pyqt5
  ];

  disabledTests = [
    # Don't run lint tests
    "test_pydocstyle"
    # https://github.com/python-lsp/python-lsp-server/issues/243
    "test_numpy_completions"
    "test_workspace_loads_pycodestyle_config"
    "test_autoimport_code_actions_and_completions_for_notebook_document"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # pyqt5 is broken on aarch64-darwin
    "test_pyqt_completion"
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [
    "pylsp"
    "pylsp.python_lsp"
  ];

  meta = with lib; {
    description = "Python implementation of the Language Server Protocol";
    homepage = "https://github.com/python-lsp/python-lsp-server";
    changelog = "https://github.com/python-lsp/python-lsp-server/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pylsp";
  };
}
