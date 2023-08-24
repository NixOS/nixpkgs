{ lib
, stdenv
, autopep8
, buildPythonPackage
, docstring-to-markdown
, fetchFromGitHub
, fetchpatch
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
, pythonRelaxDepsHook
, python-lsp-jsonrpc
, pythonOlder
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
  version = "1.7.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-plciPUROFileVULGBZpwUTkW2NZVHy4Nuf4+fSjd8nM=";
  };

  patches = [
    # https://github.com/python-lsp/python-lsp-server/pull/416
    (fetchpatch {
      name = "bump-jedi-upper-pin-to-0.20.patch";
      url = "https://github.com/python-lsp/python-lsp-server/commit/f33a93afc8c3a0f16751f9e1f6601a37967fd7df.patch";
      hash = "sha256-lBpzXxjlQp2ig0z2DRJw+jQZ5eRLIOJYjGrzfgvknDA=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov-report html --cov-report term --junitxml=pytest.xml" "" \
      --replace "--cov pylsp --cov test" ""
  '';

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

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
