{ lib
, buildPythonPackage
, fetchFromGitHub
, enaml
, pyqtgraph
, pythonocc-core
}:

buildPythonPackage rec {
  pname = "enamlx";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "frmdstryr";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rlrx3cw6h1zl9svnqbzwdfy8469qa1y7w6576lbhdwpfhpipscy";
  };

  propagatedBuildInputs = [
    enaml
    # Until https://github.com/inkcut/inkcut/issues/105 perhaps
    pyqtgraph
    pythonocc-core
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
