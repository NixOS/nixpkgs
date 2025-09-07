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
  version = "0.0.34";
  pyproject = true;

  src = fetchPypi {
    pname = "canonical_sphinx_extensions";
    inherit version;
    hash = "sha256-y9wiXj4FOkOt3Pt2EFbX5xO+f8V5eaI0G6LzuGbdY0o=";
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
