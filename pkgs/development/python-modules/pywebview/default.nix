{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  bottle,
  importlib-resources,
  proxy-tools,
  pygobject3,
  pyqtwebengine,
  pytest,
  pythonOlder,
  qt5,
  qtpy,
  six,
  xvfb-run,
}:

buildPythonPackage rec {
  pname = "pywebview";
  version = "5.2";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "r0x0r";
    repo = "pywebview";
    rev = "refs/tags/${version}";
    hash = "sha256-PNnsqb+gyeFfQwMFj7cYaiv54cZ+H5IF9+DS9RN/qB4=";
  };

  nativeBuildInputs = [
    setuptools-scm
    qt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    bottle
    pyqtwebengine
    proxy-tools
    six
  ] ++ lib.optionals (pythonOlder "3.7") [ importlib-resources ];

  nativeCheckInputs = [
    pygobject3
    pytest
    qtpy
    xvfb-run
  ];

  checkPhase = ''
    # a Qt wrapper is required to run the Qt backend
    # since the upstream script does not have a way to disable tests individually pytest is used directly instead
    makeQtWrapper "$(command -v pytest)" tests/run.sh \
      --set PYWEBVIEW_LOG debug \
      --add-flags "--deselect tests/test_js_api.py::test_concurrent"

    # HOME and XDG directories are required for the tests
    env \
      HOME=$TMPDIR \
      XDG_RUNTIME_DIR=$TMPDIR/xdg-runtime-dir \
      xvfb-run -s '-screen 0 800x600x24' tests/run.sh
  '';

  pythonImportsCheck = [ "webview" ];

  meta = with lib; {
    description = "Lightweight cross-platform wrapper around a webview";
    homepage = "https://github.com/r0x0r/pywebview";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jojosch ];
  };
}
