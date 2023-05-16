{ lib
, stdenv
, autopep8
, buildPythonPackage
, docstring-to-markdown
, fetchFromGitHub
, flake8
, flaky
<<<<<<< HEAD
, importlib-metadata
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, python-lsp-jsonrpc
, pythonOlder
, pythonRelaxDepsHook
=======
, pythonRelaxDepsHook
, python-lsp-jsonrpc
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, rope
, setuptools
, setuptools-scm
, toml
, ujson
, websockets
, whatthepatch
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, yapf
}:

buildPythonPackage rec {
  pname = "python-lsp-server";
<<<<<<< HEAD
  version = "1.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "1.7.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-hLgMGZumuNY70/qyD9t5pMpYI/g70sqFIt1LEfIEALY=";
  };

=======
    hash = "sha256-jsWk2HDDRjOAPGX1K9NqhWkA5xD2fM830z7g7Kee0yQ=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov-report html --cov-report term --junitxml=pytest.xml" "" \
      --replace "--cov pylsp --cov test" ""
  '';

<<<<<<< HEAD
  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    docstring-to-markdown
    jedi
    pluggy
    python-lsp-jsonrpc
    setuptools # `pkg_resources`imported in pylsp/config/config.py
    ujson
<<<<<<< HEAD
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
