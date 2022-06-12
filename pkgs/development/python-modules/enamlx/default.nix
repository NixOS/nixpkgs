{ lib
, buildPythonPackage
, fetchFromGitHub
, enaml
, pyqtgraph
, pythonocc-core
}:

buildPythonPackage rec {
  pname = "enamlx";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "frmdstryr";
    repo = pname;
    rev = "v${version}";
    sha256 = "10sn7wd4fjz8nkzprd8wa5da5dg8w91r0rngqaipwnpq1dz54b5s";
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
