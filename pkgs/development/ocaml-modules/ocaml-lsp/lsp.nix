{ buildDunePackage
, lib
, cppo
, stdlib-shims
, ppx_yojson_conv_lib
, ocaml-syntax-shims
, jsonrpc
, omd
, octavius
, dune-build-info
, dune-rpc
, uutf
, dyn
, re
, stdune
, chrome-trace
, dune_3
, csexp
, pp
, cmdliner
, ordering
, ocamlformat-rpc-lib
}:

buildDunePackage rec {
  pname = "lsp";
  inherit (jsonrpc) version src;
  duneVersion = if lib.versionAtLeast version "1.10.0" then "3" else "2";
  minimumOCamlVersion =
    if lib.versionAtLeast version "1.7.0" then
      "4.12"
    else
      "4.06";

  # unvendor some (not all) dependencies.
  # They are vendored by upstream only because it is then easier to install
  # ocaml-lsp without messing with your opam switch, but nix should prevent
  # this type of problems without resorting to vendoring.
  preBuild = lib.optionalString (lib.versionOlder version "1.10.4") ''
    rm -r ocaml-lsp-server/vendor/{octavius,uutf,omd,cmdliner}
  '';

  buildInputs =
    if lib.versionAtLeast version "1.12.0" then
      [
        pp
        re
        ppx_yojson_conv_lib
        octavius
        dune-build-info
        dune-rpc
        omd
        cmdliner
        ocamlformat-rpc-lib
        dyn
        stdune
        chrome-trace
      ]
    else if lib.versionAtLeast version "1.10.0" then
      [
        pp
        re
        ppx_yojson_conv_lib
        octavius
        dune-build-info
        dune-rpc
        omd
        cmdliner
        ocamlformat-rpc-lib
        dyn
        stdune
      ]
    else if lib.versionAtLeast version "1.7.0" then
      [ pp re ppx_yojson_conv_lib octavius dune-build-info omd cmdliner ocamlformat-rpc-lib ]
    else
      [
        cppo
        ppx_yojson_conv_lib
        ocaml-syntax-shims
        octavius
        dune-build-info
        omd
        cmdliner
      ];

  propagatedBuildInputs = [
    csexp
    jsonrpc
    uutf
  ] ++ lib.optional (lib.versionOlder version "1.7.0") stdlib-shims;

  meta = jsonrpc.meta // {
    description = "LSP protocol implementation in OCaml";
  };
}
