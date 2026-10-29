{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "rcssmin";
  version = "1.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-gGmG6vdBRUXtwoodKVI+lWDknhUf9KM32dHwJx1uHMQ=";
  };

  # The package does not ship tests, and the setup machinery confuses
  # tests auto-discovery
  doCheck = false;

  pythonImportsCheck = [ "rcssmin" ];

  meta = {
    description = "CSS minifier written in pure python";
    homepage = "http://opensource.perlig.de/rcssmin/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
