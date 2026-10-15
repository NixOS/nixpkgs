{
  lib,
  braq,
  buildPythonPackage,
  fetchPypi,
  paradict,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "kvf";
  version = "0.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-9IhbG75myMIP2r5c7es8Dl0SpUrElfnl/Pb+0ODFG3M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    braq
    paradict
  ];

  pythonImportsCheck = [ "kvf" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "The key-value file format with sections";
    homepage = "https://pypi.org/project/kvf/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
