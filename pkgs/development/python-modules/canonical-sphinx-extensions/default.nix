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
  version = "0.0.31";
  pyproject = true;

  src = fetchPypi {
    pname = "canonical_sphinx_extensions";
    inherit version;
    hash = "sha256-ky0+lRkYU/qI6D4sBVZjFxJvQ5E5MnQlGRWcDcE4y80=";
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
