{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-machineid";
  version = "0.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VRXV+XeQc9DKouiq8VoP3QrUJH/QuG2cRHQxyW0+NGc=";
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
