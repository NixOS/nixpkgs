{ lib, buildPythonPackage, fetchPypi, twisted, mock }:

buildPythonPackage rec {
  pname = "magic-wormhole-transit-relay";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ppsx2s1ysikns1h053x67z2zmficbn3y3kf52bzzslhd2s02j6b";
  };

  propagatedBuildInputs = [ twisted ];

  checkInputs = [ mock ];

  checkPhase = ''
    ${twisted}/bin/trial wormhole_transit_relay
  '';

  meta = with lib; {
    description = "Transit Relay server for Magic-Wormhole";
    homepage = "https://github.com/warner/magic-wormhole-transit-relay";
    license = licenses.mit;
  };
}
