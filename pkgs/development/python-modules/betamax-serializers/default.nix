{ lib, buildPythonPackage, fetchPypi
, betamax, pyyaml }:

buildPythonPackage rec {
  pname = "betamax-serializers";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ja9isbjmzzhxdj69s0kdsvw8nkp073w6an6a4liy5vk3fdl2p1l";
  };

  buildInputs = [ betamax pyyaml ];

  meta = with lib; {
    homepage = "https://gitlab.com/betamax/serializers";
    description = "A set of third-party serializers for Betamax";
    license = licenses.asl20;
  };
}
