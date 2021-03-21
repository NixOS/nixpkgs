{ buildDunePackage, jsonrpc, lsp }:

buildDunePackage {
  pname = "ocaml-lsp-server";
  inherit (jsonrpc) version src;
  useDune2 = true;

  inherit (lsp) preBuild;

  buildInputs = lsp.buildInputs ++ [ lsp ];

  meta = jsonrpc.meta // {
    description = "OCaml Language Server Protocol implementation";
  };
}
