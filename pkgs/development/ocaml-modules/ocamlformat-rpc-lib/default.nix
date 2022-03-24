{ lib, fetchurl, buildDunePackage, csexp, sexplib0 }:

buildDunePackage rec {
  pname = "ocamlformat-rpc-lib";
  version = "0.21.0";

  src = fetchurl {
    url = "https://github.com/ocaml-ppx/ocamlformat/releases/download/${version}/ocamlformat-${version}.tbz";
    sha256 = "sha256-KhgX9rxYH/DM6fCqloe4l7AnJuKrdXSe6Y1XY3BXMy0=";
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
