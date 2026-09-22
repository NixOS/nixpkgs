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

buildPythonPackage (finalAttrs: {
  pname = "plastexdepgraph";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "plastexdepgraph";
    owner = "PatrickMassot";
    tag = finalAttrs.version;
    hash = "sha256-GOTQmcWrmEZ2DkAMcE1ZknLOyVorGC87+qhO8jxcGJ4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pygraphviz
    plasTeX
  ];

  pythonImportsCheck = [ "plastexdepgraph" ];

  meta = {
    description = "PlasTeX plugin allowing to build dependency graphs";
    homepage = "https://github.com/PatrickMassot/plastexdepgraph";
    changelog = "https://github.com/PatrickMassot/plastexdepgraph/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ niklashh ];
    license = lib.licenses.asl20;
  };
})
