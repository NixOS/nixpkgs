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
  version = "0.11.10";
  pname = "matplotlib-venn";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kNDPsnnF273339ciwOJRWjf1NelJvK0XRIO8d343LmU=";
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
