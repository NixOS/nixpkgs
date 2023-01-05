{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools-scm
, pyqt-builder
, matplotlib
, orange-canvas-core
, pyqt5
, pyqtgraph
, typing-extensions
, appnope
}:

buildPythonPackage rec {
  pname = "orange-widget-base";
  version = "4.19.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "biolab";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-lC//xD+S8VB597rTcYscdat/ydUCq3nEjGAjQ7obMxY=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [
    pyqt-builder
  ];

  propagatedBuildInputs = [
    matplotlib
    orange-canvas-core
    pyqt5
    pyqtgraph
    typing-extensions
  ] ++ lib.optionals stdenv.isDarwin [
    appnope
  ];

  # FIXME: checks must be disabled because they are lacking the qt env.
  #        They fail like this, even if built and wrapped with all Qt and
  #        runtime dependencies:
  #
  #     running install tests
  #     qt.qpa.plugin: Could not find the Qt platform plugin "xcb" in ""
  #     This application failed to start because no Qt platform plugin could be initialized. Reinstalling the application may fix this problem.
  #
  #     Available platform plugins are: wayland-egl, wayland, wayland-xcomposite-egl, wayland-xcomposite-glx.
  #
  # See also https://discourse.nixos.org/t/qt-plugin-path-unset-in-test-phase/
  doCheck = false;

  meta = with lib; {
    description = "Provides a base widget component for a interactive GUI based workflow";
    longDescription = "It is primarily used in the Orange data mining application.";
    homepage = "https://orangedatamining.com/";
    changelog = "https://github.com/biolab/orange-widget-base/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ totoroot ];
  };
}
