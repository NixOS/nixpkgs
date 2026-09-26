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

  src = fetchFromGitHub {
    repo = "plastexdepgraph";
    owner = "PatrickMassot";
    rev = "0.0.4";
    hash = "sha256-Q13uYYZe1QgZHS4Nj8ugr+Fmhva98ttJj3AlXTK6XDw=";
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
