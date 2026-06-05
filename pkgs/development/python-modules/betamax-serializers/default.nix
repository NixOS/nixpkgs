{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  betamax,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "betamax-serializers";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ja9isbjmzzhxdj69s0kdsvw8nkp073w6an6a4liy5vk3fdl2p1l";
  };

  build-system = [ setuptools ];

  buildInputs = [
    betamax
    pyyaml
  ];

  meta = {
    homepage = "https://gitlab.com/betamax/serializers";
    description = "Set of third-party serializers for Betamax";
    license = lib.licenses.asl20;
  };
}
