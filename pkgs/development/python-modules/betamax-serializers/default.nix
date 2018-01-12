{ stdenv, buildPythonPackage, fetchPypi
, betamax, pyyaml }:

buildPythonPackage rec {
  pname = "betamax-serializers";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yqzwx204m4lxlpg04cwv6iwzmcpdzr19wvj97vvxchp0g4qg83d";
  };

  buildInputs = [ betamax pyyaml ];

  meta = with stdenv.lib; {
    homepage = https://gitlab.com/betamax/serializers;
    description = "A set of third-party serializers for Betamax";
    license = licenses.asl20;
  };
}
