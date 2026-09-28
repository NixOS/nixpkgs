{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  betamax,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "betamax-serializers";
  version = "0.2.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-NFxBmxtzFx8pUcYqw8cBd1rEt24T6GRk6/D/KpeOSUk=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    betamax
    pyyaml
  ];

  pythonImportsCheck = [ "betamax_serializers" ];

  meta = {
    homepage = "https://gitlab.com/betamax/serializers";
    description = "Set of third-party serializers for Betamax";
    license = lib.licenses.asl20;
  };
})
