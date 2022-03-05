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
  version = "0.4.0";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "data-encoding";
    rev = "v0.4";
    sha256 = "1f88l9azpfk730hps5v6zlg4yyyyhj1gl27qy3cbbkzjc82d2rhx";
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
