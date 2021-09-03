{ lib
, fetchFromGitLab
, buildDunePackage
, ezjsonm
, zarith
, hex
, json-data-encoding
, json-data-encoding-bson
, alcotest
, crowbar
}:

buildDunePackage {
  pname = "data-encoding";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "data-encoding";
    rev = "0.2";
    sha256 = "0d9c2ix2imqk4r0jfhnwak9laarlbsq9kmswvbnjzdm2g0hwin1d";
  };
  useDune2 = true;

  propagatedBuildInputs = [
    ezjsonm
    zarith
    hex
    json-data-encoding
    json-data-encoding-bson
  ];

  checkInputs = [
    alcotest
    crowbar
  ];

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/nomadic-labs/data-encoding";
    description = "Library of JSON and binary encoding combinators";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
