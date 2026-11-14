{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  torch,
}:

buildPythonPackage (finalAttrs: {
  pname = "julius";
  version = "0.2.8";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-1pHmUSAJMK/+pPbIScJulf7IRghyga49GndX6skCU9U=";
  };

  build-system = [ hatchling ];

  dependencies = [ torch ];

  pythonImportsCheck = [ "julius" ];

  meta = {
    description = "Module to perform resampling and FFT convolutions";
    homepage = "https://github.com/adefossez/julius";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
  };
})
