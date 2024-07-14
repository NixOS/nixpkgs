{
  lib,
  buildPythonPackage,
  fetchPypi,
  cflow,
  graphviz,
  pydot,
  networkx,
  which,
}:

buildPythonPackage rec {
  pname = "pycflow2dot";
  version = "0.2.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pZgi6KGFMCdgRStRbLC0bvmNw0sPHu6A+t9g0K7oqP4=";
  };

  propagatedBuildInputs = [
    cflow
    graphviz
    pydot
    networkx
    which
  ];

  pythonImportsCheck = [ "pycflow2dot" ];
  checkPhase = ''
    cd tests
    export PATH=$out/bin:$PATH
    make all
  '';

  meta = with lib; {
    description = "Layout C call graphs from cflow using GraphViz dot";
    mainProgram = "cflow2dot";
    homepage = "https://github.com/johnyf/pycflow2dot";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ evils ];
  };
}
