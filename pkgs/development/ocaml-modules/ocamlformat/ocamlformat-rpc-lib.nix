{ lib, fetchurl, buildDunePackage, ocaml, csexp, sexplib0 }:

# for compat with ocaml-lsp
let source =
  if lib.versionAtLeast ocaml.version "4.13"
  then {
    version = "0.26.0";
    sha256 = "sha256-AxSUq3cM7xCo9qocvrVmDkbDqmwM1FexEP7IWadeh30=";
  } else {
    version = "0.20.0";
    sha256 = "sha256-JtmNCgwjbCyUE4bWqdH5Nc2YSit+rekwS43DcviIfgk=";
  };
in

buildDunePackage rec {
  pname = "ocamlformat-rpc-lib";
  inherit (source) version;

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/ocamlformat/releases/download/${version}/ocamlformat-${version}.tbz";
    inherit (source) sha256;
  };

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  propagatedBuildInputs = [ csexp sexplib0 ];

  meta = with lib; {
    homepage = "https://github.com/ocaml-ppx/ocamlformat";
    description = "Auto-formatter for OCaml code (RPC mode)";
    license = licenses.mit;
    maintainers = with maintainers; [ Zimmi48 marsam Julow ];
  };
}
