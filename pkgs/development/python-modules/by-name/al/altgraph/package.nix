{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "altgraph";
  version = "0.17.5";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yHs5XdEvq96cmVc6l0nWfajSnvneASXH9TZpm0qbyec=";
  };

  dependencies = [
    # setuptools in dependencies is intentional
    # https://github.com/ronaldoussoren/altgraph/issues/21
    setuptools
  ];

  pythonImportsCheck = [ "altgraph" ];

  meta = {
    changelog = "https://github.com/ronaldoussoren/altgraph/tags${version}";
    description = "Fork of graphlib: a graph (network) package for constructing graphs";
    longDescription = ''
      altgraph is a fork of graphlib: a graph (network) package for constructing graphs,
      BFS and DFS traversals, topological sort, shortest paths, etc. with graphviz output.
      altgraph includes some additional usage of Python 2.6+ features and enhancements related to modulegraph and macholib.
    '';
    homepage = "https://altgraph.readthedocs.io/";
    downloadPage = "https://pypi.org/project/altgraph/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ septem9er ];
  };
}
