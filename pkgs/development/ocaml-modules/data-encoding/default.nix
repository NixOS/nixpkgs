{ lib
, fetchFromGitLab
, buildDunePackage
, ezjsonm
, zarith
, zarith_stubs_js
, hex
, json-data-encoding
, json-data-encoding-bson
, either
, alcotest
, crowbar
}:

buildDunePackage {
  pname = "data-encoding";
  version = "0.5.3";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "data-encoding";
    rev = "v0.5.3";
    sha256 = "0626pvwjbhfk6iiyqdk88c8a3x1sdlr4c3blj4zzbvki3s76khqw";
  };
  useDune2 = true;

  propagatedBuildInputs = [
    ezjsonm
    zarith
    zarith_stubs_js
    hex
    json-data-encoding
    json-data-encoding-bson
    either
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
