{
  lib,
  betamax,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "betamax-serializers";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NFxBmxtzFx8pUcYqw8cBd1rEt24T6GRk6/D/KpeOSUk=";
  };

  build-system = [ setuptools ];

  dependencies = [ betamax ];

  passthru.optional-dependencies = {
    yaml11 = [ pyyaml ];
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "betamax_serializers" ];

  meta = with lib; {
    description = "A set of third-party serializers for Betamax";
    homepage = "https://gitlab.com/betamax/serializers";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
