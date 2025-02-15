{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  matplotlib,
  numpy,
  scipy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "1.1.1";
  pname = "matplotlib-venn";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2IW8AV9QkaS4qBOP8gp+0WbDO1w228BIn5Wly8dqKuU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    matplotlib
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Functions for plotting area-proportional two- and three-way Venn diagrams in matplotlib";
    homepage = "https://github.com/konstantint/matplotlib-venn";
    changelog = "https://github.com/konstantint/matplotlib-venn/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
