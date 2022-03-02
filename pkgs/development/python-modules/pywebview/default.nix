{ lib
, buildPythonPackage
, fetchFromGitHub
, importlib-resources
, pyqtwebengine
, pytest
, pythonOlder
, qt5
, xvfb-run
, proxy_tools
}:

buildPythonPackage rec {
  pname = "pywebview";
  version = "3.6.1";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "r0x0r";
    repo = "pywebview";
    rev = version;
    sha256 = "sha256-9o9ghqvU9Hnmf2aj/BqX7WBgS9ilRSnicR+qd25OfjI=";
  };

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    pyqtwebengine
    proxy_tools
  ] ++ lib.optionals (pythonOlder "3.7") [ importlib-resources ];

  checkInputs = [
    pytest
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

  pythonImportsCheck = [ "webview" ];

  meta = with lib; {
    homepage = "https://github.com/r0x0r/pywebview";
    description = "Lightweight cross-platform wrapper around a webview";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jojosch ];
  };
}
