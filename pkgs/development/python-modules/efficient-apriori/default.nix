{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "efficient-apriori";
  version = "2.0.6";

  pyproject = true;

  src = fetchPypi {
    pname = "efficient_apriori";
    inherit version;
    hash = "sha256-WtjOS0+K7lPMDvmagEFFBxvYvdZS/ft4zfLkODG6rW4=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "efficient_apriori"
  ];

  meta = {
    description = "An efficient Python implementation of the Apriori algorithm";
    homepage = "https://github.com/tommyod/Efficient-Apriori";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rutwik1221 ];
  };
}
