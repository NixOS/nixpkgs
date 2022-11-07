{ lib
, buildPythonPackage
, fetchFromGitHub
, importlib-resources
, proxy_tools
, pygobject3
, pyqtwebengine
, pytest
, pythonOlder
, qt5
, qtpy
, six
, xvfb-run
}:

buildPythonPackage rec {
  pname = "pywebview";
  version = "3.7";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "r0x0r";
    repo = "pywebview";
    rev = "refs/tags/${version}";
    hash = "sha256-RRq6b0hqAzig/WwFK0VsrhHO6ar8HhMdAEIosPPNUQg=";
  };

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    pyqtwebengine
    proxy_tools
    six
  ] ++ lib.optionals (pythonOlder "3.7") [
    importlib-resources
  ];

  checkInputs = [
    pygobject3
    pytest
    qtpy
    xvfb-run
  ];

  checkPhase = ''
    # Cannot create directory /homeless-shelter/.... Error: FILE_ERROR_ACCESS_DENIED
    export HOME=$TMPDIR
    # QStandardPaths: XDG_RUNTIME_DIR not set
    export XDG_RUNTIME_DIR=$HOME/xdg-runtime-dir

    pushd tests
    substituteInPlace run.sh \
      --replace "PYTHONPATH=.." "PYTHONPATH=$PYTHONPATH" \
      --replace "pywebviewtest test_js_api.py::test_concurrent ''${PYTEST_OPTIONS}" "# skip flaky test_js_api.py::test_concurrent"

    patchShebangs run.sh
    wrapQtApp run.sh

    xvfb-run -s '-screen 0 800x600x24' ./run.sh
    popd
  '';

  pythonImportsCheck = [
    "webview"
  ];

  meta = with lib; {
    description = "Lightweight cross-platform wrapper around a webview";
    homepage = "https://github.com/r0x0r/pywebview";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jojosch ];
  };
}
