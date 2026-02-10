{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  enaml,
  pyqtgraph,
  pythonocc-core,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "enamlx";
  version = "0.6.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "frmdstryr";
    repo = "enamlx";
    tag = "v${version}";
    hash = "sha256-C3/G0bnu1EQh0elqdrpCwkFPZU4qmkUX7WRSRK9nkM4=";
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

  meta = {
    homepage = "https://github.com/frmdstryr/enamlx";
    description = "Additional Qt Widgets for Enaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raboof ];
  };
}
