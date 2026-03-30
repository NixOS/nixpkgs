{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  requests-oauthlib,
  voluptuous,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pybotvac";
  version = "0.0.28";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XIGG8HmjI3dSq42co2e05xHIYjIM39qVanMJLDqWFCg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    requests-oauthlib
    voluptuous
  ];

  # Module no tests
  doCheck = false;

  pythonImportsCheck = [ "pybotvac" ];

  meta = {
    description = "Python module for interacting with Neato Botvac Connected vacuum robots";
    homepage = "https://github.com/stianaske/pybotvac";
    changelog = "https://github.com/stianaske/pybotvac/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
