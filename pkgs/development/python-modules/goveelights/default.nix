{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "goveelights";
  version = "0.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A7tfY+aFzhfruCZ43usj1/CsTejbPMzHM8SYrY/TU1s=";
  };

  propagatedBuildInputs = [ requests ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "goveelights" ];

  meta = {
    description = "Python module for interacting with the Govee API";
    homepage = "https://github.com/arcanearronax/govee_lights";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
