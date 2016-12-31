{ pkgs
, build-idris-package
, fetchFromGitHub
, lightyear
, contrib
, lib
, idris
}:

let
  date = "2016-12-20";
in
build-idris-package {
  name = "httpclient-${date}";

  src = fetchFromGitHub {
    owner = "justjoheinz";
    repo = "idris-httpclient";
    rev = "4a7296d572d7f7fde87d27da07d5c9566dc4ff14";
    sha256 = "0sy0q7gri9lwbqdmx9720pby3w1470w7wzn62bf2rir532219hhl";
  };

  propagatedBuildInputs = [ pkgs.curl lightyear contrib ];

  meta = {
    description = "HTTP Client for Idris";
    homepage = https://github.com/justjoheinz/idris-httpclient;
    inherit (idris.meta) platforms;
  };
}
