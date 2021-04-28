{ buildDunePackage, jsonrpc, lsp, makeWrapper, dot-merlin-reader }:

buildDunePackage {
  pname = "ocaml-lsp-server";
  inherit (jsonrpc) version src;
  useDune2 = true;

  inherit (lsp) preBuild;

  buildInputs = lsp.buildInputs ++ [ lsp ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/ocamllsp --prefix PATH : ${dot-merlin-reader}/bin
  '';

  meta = jsonrpc.meta // {
    description = "OCaml Language Server Protocol implementation";
  };
}
