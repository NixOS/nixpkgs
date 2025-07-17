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
  version = "0.0.27";
  pyproject = true;

  src = fetchPypi {
    pname = "canonical_sphinx_extensions";
    inherit version;
    hash = "sha256-ZorSmn+PAVS8xO7X3zk6u3W7pn3JB9w0PhFAXzv6l78=";
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
    description = "A collection of Sphinx extensions used by Canonical documentation";
    homepage = "https://pypi.org/project/canonical-sphinx-extensions";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
