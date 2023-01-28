{ lib
, fetchFromGitLab
, buildDunePackage
, ppx_hash
, either
, ezjsonm
, zarith
, zarith_stubs_js
, hex
, json-data-encoding
, json-data-encoding-bson
, alcotest
, crowbar
, ppx_expect
}:

buildDunePackage {
  pname = "data-encoding";
  version = "0.5.3";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "data-encoding";
    rev = "v0.5.3";
    sha256 = "sha256-HMNpjh5x7vU/kXQNRjJtOvShEENoNuxjNNPBJfm+Rhg=";
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

  nativeCheckInputs = [
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
