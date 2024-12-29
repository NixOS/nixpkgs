{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ocaml,
  ppxlib,
  ounit,
  ounit2,
  ppx_deriving,
  result,
  yojson,
}:

let
  param =
    if lib.versionAtLeast ppxlib.version "0.30" then
      {
        version = "3.9.0";
        sha256 = "sha256-0d6YcBkeFoHXffCYjLIIvruw8B9ZB6NbUijhTv9uyN8=";
        checkInputs = [ ounit2 ];
      }
    else
      {
        version = "3.6.1";
        sha256 = "1icz5h6p3pfj7my5gi7wxpflrb8c902dqa17f9w424njilnpyrbk";
        checkInputs = [ ounit ];
        propagatedBuildInputs = [ result ];
      };
in

buildDunePackage rec {
  pname = "ppx_deriving_yojson";
  inherit (param) version;

  minimalOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = "ppx_deriving_yojson";
    rev = "v${version}";
    inherit (param) sha256;
  };

  propagatedBuildInputs = [
    ppxlib
    ppx_deriving
    yojson
  ] ++ param.propagatedBuildInputs or [ ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  inherit (param) checkInputs;

  meta = {
    description = "Yojson codec generator for OCaml >= 4.04";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
