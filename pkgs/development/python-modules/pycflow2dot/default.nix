{
  lib,
  buildPythonPackage,
  fetchPypi,
  cflow,
  graphviz,
  pydot,
  networkx,
  pkg-resources-backport,
  setuptools,
  which,
}:

buildPythonPackage rec {
  pname = "pycflow2dot";
  version = "0.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pZgi6KGFMCdgRStRbLC0bvmNw0sPHu6A+t9g0K7oqP4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cflow
    graphviz
    pydot
    pkg-resources-backport
    networkx
    which
  ];

  pythonImportsCheck = [ "pycflow2dot" ];

  checkPhase = ''
    cd tests
    export PATH=$out/bin:$PATH
    make all
  '';

  meta = {
    description = "Layout C call graphs from cflow using GraphViz dot";
    homepage = "https://github.com/johnyf/pycflow2dot";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "cflow2dot";
  };
}
