{ lib, buildPythonPackage, fetchPypi, twisted, mock }:

buildPythonPackage rec {
  pname = "magic-wormhole-transit-relay";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b13f1bfab295150b25958014d93fcd9f744d92011d186d7381575465587b8587";
  };

  propagatedBuildInputs = [ twisted ];

  checkInputs = [ mock ];

  checkPhase = ''
    ${twisted}/bin/trial wormhole_transit_relay
  '';

  meta = with lib; {
    description = "Transit Relay server for Magic-Wormhole";
    homepage = https://github.com/warner/magic-wormhole-transit-relay;
    license = licenses.mit;
  };
}
