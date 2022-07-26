{ lib, fetchurl, buildDunePackage, ocaml, csexp, sexplib0 }:

# for compat with ocaml-lsp
let source =
  if lib.versionAtLeast ocaml.version "4.13"
  then {
    version = "0.21.0";
    sha256 = "sha256-KhgX9rxYH/DM6fCqloe4l7AnJuKrdXSe6Y1XY3BXMy0=";
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

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  propagatedBuildInputs = [ csexp sexplib0 ];

  meta = with lib; {
    homepage = "https://github.com/ocaml-ppx/ocamlformat";
    description = "Auto-formatter for OCaml code (RPC mode)";
    license = licenses.mit;
    maintainers = with maintainers; [ Zimmi48 marsam ];
  };
}
