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
, csexp
, result
, pp
, cmdliner
, ordering
, ocamlformat-rpc-lib
, ocaml
, version ?
    if lib.versionAtLeast ocaml.version "5.02" then
      "1.19.0"
    else if lib.versionAtLeast ocaml.version "4.14" then
      "1.18.0"
    else if lib.versionAtLeast ocaml.version "4.13" then
      "1.10.5"
    else if lib.versionAtLeast ocaml.version "4.12" then
      "1.9.0"
    else
      "1.4.1"
}:

let jsonrpc_v = jsonrpc.override {
  inherit version;
}; in
buildDunePackage rec {
  pname = "lsp";
  inherit (jsonrpc_v) version src;
  minimalOCamlVersion =
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
        ppx_yojson_conv_lib
        ocaml-syntax-shims
        octavius
        dune-build-info
        omd
        cmdliner
      ];

  nativeBuildInputs = lib.optional (lib.versionOlder version "1.7.0") cppo;

  propagatedBuildInputs =
    if lib.versionAtLeast version "1.14.0" then [
      jsonrpc
      ppx_yojson_conv_lib
      uutf
    ] else if lib.versionAtLeast version "1.10.0" then [
      dyn
      jsonrpc
      ordering
      ppx_yojson_conv_lib
      stdune
      uutf
    ] else if lib.versionAtLeast version "1.7.0" then [
      csexp
      jsonrpc
      pp
      ppx_yojson_conv_lib
      result
      uutf
    ] else [
      csexp
      jsonrpc
      ppx_yojson_conv_lib
      stdlib-shims
      uutf
    ];

  meta = jsonrpc.meta // {
    description = "LSP protocol implementation in OCaml";
  };
}
