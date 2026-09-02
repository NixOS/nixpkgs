{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyitachip2ir2";
  version = "0.0.8";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-QBBajL3UCVPrIMmff9L//gGsHF0WDRnbfc8hV1tWMxE=";
  };

  build-system = [ setuptools ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyitachip2ir" ];

  meta = {
    description = "Library for sending IR commands to an ITach IP2IR gateway";
    homepage = "https://github.com/alanfischer/itachip2ir";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
