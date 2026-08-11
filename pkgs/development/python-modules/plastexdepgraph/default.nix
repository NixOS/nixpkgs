{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pygraphviz,
  plasTeX,
}:
buildPythonPackage {
  pname = "plastexdepgraph";
  version = "0.0.5";
  pyproject = true;

  src = self.fetchFromGitHub {
    repo = "plastexdepgraph";
    owner = "PatrickMassot";
    rev = "0.0.5";
    hash = "sha256-GOTQmcWrmEZ2DkAMcE1ZknLOyVorGC87+qhO8jxcGJ4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pygraphviz
    plasTeX
  ];

  meta = {
    description = "PlasTeX plugin allowing to build dependency graphs";
    homepage = "https://github.com/PatrickMassot/plastexdepgraph";
    maintainers = with lib.maintainers; [ niklashh ];
    license = lib.licenses.asl20;
  };
}
