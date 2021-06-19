{ lib
, buildPythonPackage
, fetchFromGitHub
, enaml
, pyqtgraph
, pythonocc-core
}:

buildPythonPackage rec {
  pname = "enamlx";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "frmdstryr";
    repo = pname;
    rev = "v${version}";
    sha256 = "144bsh6lfrrjk6dygrbc2bfhlv742avj53awxnhgai04hab0214r";
  };

  patches = [
    # Minimally modified version of https://github.com/frmdstryr/enamlx/commit/16df11227b8cee724624541d274e481802ea67e3
    # (without the change to setup.py), already on master and expected in the first post-0.4.3 release
    ./replace-unicode-with-str.patch
  ];

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
