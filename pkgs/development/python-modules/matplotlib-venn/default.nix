{
  lib,
  stdenv,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  matplotlib,
  numpy,
  scipy,
  shapely,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "matplotlib-venn";
  version = "1.1.1";

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
    shapely
  ];

  disabledTests = [
    # See https://github.com/konstantint/matplotlib-venn/issues/85
    "matplotlib_venn.layout.venn3.cost_based.LayoutAlgorithm"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Functions for plotting area-proportional two- and three-way Venn diagrams in matplotlib";
    homepage = "https://github.com/konstantint/matplotlib-venn";
    changelog = "https://github.com/konstantint/matplotlib-venn/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    broken = stdenv.hostPlatform.isDarwin; # https://github.com/konstantint/matplotlib-venn/issues/87
  };
}
