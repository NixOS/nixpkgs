{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pysesame2";
  version = "1.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-djKvmmYePdpcMt9bKkQyKsKAT5hhXMPJwC0EkfY8vWU=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "pysesame2" ];

  # No tests in repository
  doCheck = false;

  meta = {
    description = "Python API for Sesame Smartlock made by CANDY HOUSE";
    homepage = "https://github.com/yagami-cerberus/pysesame2";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
