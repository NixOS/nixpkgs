{ lib, fetchurl, buildDunePackage, csexp, sexplib0 }:

buildDunePackage rec {
  pname = "ocamlformat-rpc-lib";
  version = "0.19.0";

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/ocamlformat/releases/download/${version}/ocamlformat-${version}.tbz";
    sha256 = "sha256-YvxGqujwpKM85/jXcm1xCb/2Fepvy1DRSC8h0g7lD0Y=";
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
