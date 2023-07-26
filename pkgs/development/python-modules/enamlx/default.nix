{ lib
, buildPythonPackage
, fetchFromGitHub
, enaml
, pyqtgraph
, pythonocc-core
, typing-extensions
}:

buildPythonPackage rec {
  pname = "enamlx";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "frmdstryr";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-LHqOZ1uLWFbUeQAGKoMH9GljhRq1K4RTVWzgV/pt3g8=";
  };

  propagatedBuildInputs = [
    enaml
    # Until https://github.com/inkcut/inkcut/issues/105 perhaps
    pyqtgraph
    pythonocc-core
    typing-extensions
  ];

  # qt_occ_viewer test requires enaml.qt.QtOpenGL which got dropped somewhere
  # between enaml 0.9.0 and 0.10.0
  doCheck = false;

  pythonImportsCheck = [
    "enamlx.core"
    "enamlx.qt"
    "enamlx.widgets"
  ];

  meta = with lib; {
    homepage = "https://github.com/frmdstryr/enamlx";
    description = "Additional Qt Widgets for Enaml";
    license = licenses.mit;
    maintainers = with maintainers; [ raboof ];
  };
}
