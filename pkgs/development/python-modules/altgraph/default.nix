{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "altgraph";
  version = "0.17.4";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-G1r7uY9sTcrbLirmq5+plLu4wddfT6ltNA+UN65FRAY=";
  };

  pythonImportsCheck = [ "altgraph" ];

  meta = with lib; {
    changelog = "https://github.com/ronaldoussoren/altgraph/tags${version}";
    description = "A fork of graphlib: a graph (network) package for constructing graphs";
    longDescription = ''
      altgraph is a fork of graphlib: a graph (network) package for constructing graphs,
      BFS and DFS traversals, topological sort, shortest paths, etc. with graphviz output.
      altgraph includes some additional usage of Python 2.6+ features and enhancements related to modulegraph and macholib.
    '';
    homepage = "https://altgraph.readthedocs.io/";
    downloadPage = "https://pypi.org/project/altgraph/";
    license = licenses.mit;
    maintainers = with maintainers; [ septem9er ];
  };
}
