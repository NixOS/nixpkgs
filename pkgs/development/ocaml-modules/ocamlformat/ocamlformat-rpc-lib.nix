# Version can be selected with the 'version' argument, see generic.nix.
{ lib, fetchurl, buildDunePackage, ocaml, csexp, sexplib0, callPackage, ... }@args:

let
  # for compat with ocaml-lsp
  version_arg =
    if lib.versionAtLeast ocaml.version "4.13" then {} else { version = "0.20.0"; };

  inherit (callPackage ./generic.nix (args // version_arg)) src version;

in buildDunePackage rec {
  pname = "ocamlformat-rpc-lib";
  inherit src version;

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
