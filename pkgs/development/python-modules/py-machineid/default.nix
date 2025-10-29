{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-machineid";
  version = "0.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5QQWIhI1yHR1nhnLZOhJne8Sr8K9/9N3v9aPR395ncg=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "machineid" ];

  # Tests are not present in Pypi archive
  doCheck = false;

  meta = {
    description = "Get the unique machine ID of any host (without admin privileges)";
    homepage = "https://github.com/keygen-sh/py-machineid";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
