{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "escapism";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rdEw5IqFuxquo+dPsDH1AzxwVa7bOaMmX5I9X0DD+XQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  # No tests distributed
  doCheck = false;

  meta = {
    description = "Simple, generic API for escaping strings";
    homepage = "https://github.com/minrk/escapism";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bzizou ];
  };
}
