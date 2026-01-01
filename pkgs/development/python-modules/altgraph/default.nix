{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "altgraph";
<<<<<<< HEAD
  version = "0.17.5";
=======
  version = "0.17.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-yHs5XdEvq96cmVc6l0nWfajSnvneASXH9TZpm0qbyec=";
=======
    hash = "sha256-G1r7uY9sTcrbLirmq5+plLu4wddfT6ltNA+UN65FRAY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dependencies = [
    # setuptools in dependencies is intentional
    # https://github.com/ronaldoussoren/altgraph/issues/21
    setuptools
  ];

  pythonImportsCheck = [ "altgraph" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    changelog = "https://github.com/ronaldoussoren/altgraph/tags${version}";
    description = "Fork of graphlib: a graph (network) package for constructing graphs";
    longDescription = ''
      altgraph is a fork of graphlib: a graph (network) package for constructing graphs,
      BFS and DFS traversals, topological sort, shortest paths, etc. with graphviz output.
      altgraph includes some additional usage of Python 2.6+ features and enhancements related to modulegraph and macholib.
    '';
    homepage = "https://altgraph.readthedocs.io/";
    downloadPage = "https://pypi.org/project/altgraph/";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ septem9er ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ septem9er ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
