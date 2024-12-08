{ lib
, buildDunePackage
, ppx_hash
, bigstringaf
, either
, ezjsonm
, zarith
, zarith_stubs_js ? null
, hex
, json-data-encoding
, json-data-encoding-bson
, ppx_expect
}:

buildDunePackage rec {
  pname = "data-encoding";
  inherit (json-data-encoding) src version;

  minimalOCamlVersion = "4.10";

  propagatedBuildInputs = [
    bigstringaf
    either
    ezjsonm
    ppx_hash
    zarith
    zarith_stubs_js
    hex
    json-data-encoding
    json-data-encoding-bson
  ];

  buildInputs = [
    ppx_expect
  ];

  meta = {
    homepage = "https://gitlab.com/nomadic-labs/data-encoding";
    description = "Library of JSON and binary encoding combinators";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
