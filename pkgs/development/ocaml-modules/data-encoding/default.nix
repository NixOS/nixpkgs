{ lib
, fetchFromGitLab
, buildDunePackage
, ppx_hash
, either
, ezjsonm
, zarith
, zarith_stubs_js ? null
, hex
, json-data-encoding
, json-data-encoding-bson
, alcotest
, crowbar
, ppx_expect
}:

buildDunePackage rec {
  pname = "data-encoding";
  version = "0.6";

  duneVersion = "3";
  minimalOCamlVersion = "4.10";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "data-encoding";
    rev = "v${version}";
    hash = "sha256-oQEV7lTG+/q1UcPsepPM4yN4qia6tEtRPkTkTVdGXE0=";
  };

  propagatedBuildInputs = [
    either
    ezjsonm
    ppx_hash
    zarith
    zarith_stubs_js
    hex
    json-data-encoding
    json-data-encoding-bson
  ];

  checkInputs = [
    alcotest
    crowbar
    ppx_expect
  ];

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/nomadic-labs/data-encoding";
    description = "Library of JSON and binary encoding combinators";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
