{ buildPythonPackage
, lib
, fetchPypi
, protobuf
}:

buildPythonPackage rec {
  pname = "s2clientprotocol";
  version = "3.19.1.58600.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02jqwdfj5zpag4c5nf0707qmwk7sqm98yfgrd19rq6pi58zgl74f";
  };

  patches = [ ./pure-version.patch ];

  buildInputs = [ protobuf ];

  meta = {
    description = "StarCraft II - client protocol.";
    homepage = "https://github.com/Blizzard/sc2client-proto";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
