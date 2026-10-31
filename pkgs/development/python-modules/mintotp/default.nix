{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mintotp";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-0PTbXts4p0gRIBdqUm6MKVObnoBYHdLcwYEVV9d8+tU=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "mintotp" ];

  meta = {
    description = "Minimal TOTP generator";
    homepage = "https://github.com/susam/mintotp";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lucasew ];
  };
})
