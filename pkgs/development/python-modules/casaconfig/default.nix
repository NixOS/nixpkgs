{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  certifi,
}:
buildPythonPackage (finalAttrs: {
  pname = "casaconfig";
  version = "1.5.0";

  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-/O0rzef1Yqn+ezjTWfe1oRIh6FyU1W3Ev9tuXldukys=";
  };

  build-system = [ setuptools ];

  dependencies = [ certifi ];

  meta = {
    description = "Reference data and converters for CASA operation";
    homepage = "https://casa.nrao.edu/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kiranshila ];
    platforms = lib.platforms.all;
  };
})
