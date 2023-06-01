{ lib
, atom
, buildPythonPackage
, bytecode
, cppy
, fetchFromGitHub
, kiwisolver
, pegen
, ply
, qtpy
, setuptools
, setuptools-scm
, pythonOlder
, sip
}:

buildPythonPackage rec {
  pname = "enaml";
  version = "0.16.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nucleic";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-bXbexHd/SJjfAAREhQ8V4PekI9mle3GcUPjMn0zDAyw=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    atom
    bytecode
    cppy
    kiwisolver
    pegen
    ply
    qtpy
    sip
  ];

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

  meta = with lib; {
    description = "Declarative User Interfaces for Python";
    homepage = "https://github.com/nucleic/enaml";
    changelog = "https://github.com/nucleic/enaml/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ raboof ];
  };
}
