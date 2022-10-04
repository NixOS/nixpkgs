{ buildPythonPackage
, lib
, fetchFromGitHub
, protobuf
}:

buildPythonPackage rec {
  pname = "s2clientprotocol";
  version = "5.0.10.88500.0";

  src = fetchFromGitHub {
    owner = "Blizzard";
    repo = "s2client-proto";
    rev = "db142363be5e4da522879b8b43db69c6313bcd57";
    hash = "sha256-wKbE5s0Xu+IHHrJQhVpWWWVo9UyVM2y9jrwUGnD+Zt0=";
  };

  buildInputs = [ protobuf ];

  meta = {
    description = "StarCraft II - client protocol.";
    homepage = "https://github.com/Blizzard/sc2client-proto";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
