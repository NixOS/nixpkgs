{ lib, buildPythonPackage, fetchPypi, twisted, mock }:

buildPythonPackage rec {
  pname = "magic-wormhole-transit-relay";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "faac36266c72745102a1a8b93abc5b25feed1be5bca7b29968a156966c312567";
  };

  propagatedBuildInputs = [ twisted ];

  checkInputs = [ mock ];

  checkPhase = ''
    python -m twisted.trial wormhole_transit_relay
  '';

  meta = with lib; {
    description = "Transit Relay server for Magic-Wormhole";
    homepage = https://github.com/warner/magic-wormhole-transit-relay;
    license = licenses.mit;
  };
}
