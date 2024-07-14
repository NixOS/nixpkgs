{
  lib,
  buildPythonPackage,
  fetchPypi,
  betamax,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "betamax-serializers";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NFxBmxtzFx8pUcYqw8cBd1rEt24T6GRk6/D/KpeOSUk=";
  };

  buildInputs = [
    betamax
    pyyaml
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/betamax/serializers";
    description = "Set of third-party serializers for Betamax";
    license = licenses.asl20;
  };
}
