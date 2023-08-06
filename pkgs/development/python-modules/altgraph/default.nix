{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "altgraph";
  version = "0.17.3";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad33358114df7c9416cdb8fa1eaa5852166c505118717021c6a8c7c7abbd03dd";
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
