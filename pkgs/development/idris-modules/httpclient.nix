{ curl
, build-idris-package
, fetchFromGitHub
, lightyear
, contrib
, effects
, prelude
, base
, lib
, idris
}:

let
in
build-idris-package {
  name = "httpclient";
  version = "2016-12-20";

  src = fetchFromGitHub {
    owner = "justjoheinz";
    repo = "idris-httpclient";
    rev = "4a7296d572d7f7fde87d27da07d5c9566dc4ff14";
    sha256 = "0sy0q7gri9lwbqdmx9720pby3w1470w7wzn62bf2rir532219hhl";
  };

  idrisDeps = [ prelude base effects lightyear contrib ];

  extraBuildInputs = [ curl ];

  meta = {
    description = "HTTP Client for Idris";
    homepage = https://github.com/justjoheinz/idris-httpclient;
    inherit (idris.meta) platforms;
    broken = true;
  };
}
