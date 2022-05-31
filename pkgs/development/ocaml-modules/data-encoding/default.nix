{ lib
, fetchFromGitLab
, buildDunePackage
, ocaml
, ezjsonm
, zarith
, hex
, json-data-encoding
, json-data-encoding-bson
, alcotest
, crowbar
, either
, zarith_stubs_js
}:

buildDunePackage rec {
  pname = "data-encoding";
  version = "0.5.3";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HMNpjh5x7vU/kXQNRjJtOvShEENoNuxjNNPBJfm+Rhg=";
  };

  propagatedBuildInputs = [
    ezjsonm
    zarith
    hex
    json-data-encoding
    json-data-encoding-bson
    either
    zarith_stubs_js
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
    inherit (ocaml.meta) platforms;
  };
}
