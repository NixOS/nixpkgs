{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage rec {
  pname = "ovld";
  version = "0.4.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eJEIbQTjRkGhHYCI8oQmtKVZcfVPVbf1J4c546iScWg=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "ovld" ];

  meta = {
    description = "Advanced multiple dispatch for Python functions";
    homepage = "https://github.com/breuleux/ovld";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
