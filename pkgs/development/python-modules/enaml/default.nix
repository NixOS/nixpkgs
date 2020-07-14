{ lib
, buildPythonPackage
, fetchFromGitHub
, atom
, ply
, kiwisolver
, qtpy
, sip
, cppy
, bytecode
}:

buildPythonPackage rec {
  pname = "enaml";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "nucleic";
    repo = pname;
    rev = version;
    sha256 = "1in5qa5j96qs3gsv8yaxs1l6dbm69xhzvc0pbzg0dd9kpqxfdy1j";
  };

  # qt bindings cannot be found during tests
  doCheck = false;

  pythonImportsCheck = [
    "enaml"
    "enaml.applib"
    "enaml.core"
    "enaml.core.parser"
    "enaml.layout"
    # qt bindings cannot be found during checking
    #"enaml.qt"
    #"enaml.qt.docking"
    "enaml.scintilla"
    "enaml.stdlib"
    "enaml.widgets"
    "enaml.workbench"
  ];

  propagatedBuildInputs = [
    atom
    ply
    kiwisolver
    qtpy
    sip
    cppy
    bytecode
  ];

  meta = with lib; {
    homepage = "https://github.com/nucleic/enaml";
    description = "Declarative User Interfaces for Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ raboof ];
  };
}
