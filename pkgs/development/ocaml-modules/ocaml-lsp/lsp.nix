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
, uutf
, pp
, csexp
, cmdliner
}:

buildDunePackage {
  pname = "lsp";
  inherit (jsonrpc) version src;
  useDune2 = true;
  minimumOCamlVersion = "4.06";

  # unvendor some (not all) dependencies.
  # They are vendored by upstream only because it is then easier to install
  # ocaml-lsp without messing with your opam switch, but nix should prevent
  # this type of problems without resorting to vendoring.
  preBuild = ''
    rm -r ocaml-lsp-server/vendor/{octavius,uutf,omd,cmdliner}
  '';

  buildInputs = [
    cppo
    ppx_yojson_conv_lib
    ocaml-syntax-shims
    octavius
    dune-build-info
    omd
    cmdliner
  ] ++ lib.optional (lib.versionAtLeast jsonrpc.version "1.7.0") pp;

  propagatedBuildInputs = [
    csexp
    jsonrpc
    stdlib-shims
    uutf
  ];

  meta = jsonrpc.meta // {
    description = "LSP protocol implementation in OCaml";
  };
}
