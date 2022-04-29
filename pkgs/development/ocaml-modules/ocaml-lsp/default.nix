{ lib, buildDunePackage, jsonrpc, lsp, re, makeWrapper, dot-merlin-reader, spawn }:

buildDunePackage {
  pname = "ocaml-lsp-server";
  inherit (jsonrpc) version src;
  useDune2 = true;

  inherit (lsp) preBuild;

  buildInputs = lsp.buildInputs ++ [ lsp re ]
  ++ lib.optional (lib.versionAtLeast jsonrpc.version "1.9") spawn;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/ocamllsp --prefix PATH : ${dot-merlin-reader}/bin
  '';

  meta = jsonrpc.meta // {
    description = "OCaml Language Server Protocol implementation";
  };
}
