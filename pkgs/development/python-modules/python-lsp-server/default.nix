{ lib
, stdenv
, autopep8
, buildPythonPackage
, docstring-to-markdown
, fetchFromGitHub
, flake8
, flaky
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
, rope
, setuptools
, setuptools-scm
, toml
, ujson
, websockets
, whatthepatch
, yapf
}:

buildPythonPackage rec {
  pname = "python-lsp-server";
  version = "1.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-9cyzJxyCris7FsVni5IZCCL6IAcsN8tMakNoKPeWv7s=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov-report html --cov-report term --junitxml=pytest.xml" "" \
      --replace "--cov pylsp --cov test" "" \
      --replace "autopep8>=1.6.0,<1.7.0" "autopep8" \
      --replace "flake8>=5.0.0,<5.1.0" "flake8" \
      --replace "mccabe>=0.7.0,<0.8.0" "mccabe" \
      --replace "pycodestyle>=2.9.0,<2.10.0" "pycodestyle" \
      --replace "pyflakes>=2.5.0,<2.6.0" "pyflakes"
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    docstring-to-markdown
    jedi
    pluggy
    python-lsp-jsonrpc
    setuptools # `pkg_resources`imported in pylsp/config/config.py
    ujson
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

  checkInputs = [
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
    # https://github.com/python-lsp/python-lsp-server/issues/243
    "test_numpy_completions"
    "test_workspace_loads_pycodestyle_config"
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
