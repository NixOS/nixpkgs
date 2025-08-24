{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  beautifulsoup4,
  docutils,
  gitpython,
  requests,
  sphinx,
}:

buildPythonPackage rec {
  pname = "canonical-sphinx-extensions";
  version = "0.0.33";
  pyproject = true;

  src = fetchPypi {
    pname = "canonical_sphinx_extensions";
    inherit version;
    hash = "sha256-Rb4FK1e0pb+fub58Fq61i3kMhRm/nekHNr91zft8iJY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    beautifulsoup4
    docutils
    gitpython
    requests
    sphinx
  ];

  doCheck = false;

  meta = {
    description = "Collection of Sphinx extensions used by Canonical documentation";
    homepage = "https://pypi.org/project/canonical-sphinx-extensions";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
