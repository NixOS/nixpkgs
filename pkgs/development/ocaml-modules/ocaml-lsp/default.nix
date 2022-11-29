{ lib, buildDunePackage, lsp, xdg, re, fiber, makeWrapper, dot-merlin-reader, spawn, ocamlc-loc }:

buildDunePackage rec {
  pname = "ocaml-lsp-server";
  inherit (lsp) version src preBuild;
  duneVersion = if lib.versionAtLeast version "1.10.0" then "3" else "2";

  buildInputs = lsp.buildInputs ++ [ lsp re ]
  ++ lib.optional (lib.versionAtLeast version "1.9") spawn
  ++ lib.optionals (lib.versionAtLeast version "1.10") [ fiber xdg ]
  ++ lib.optional (lib.versionAtLeast version "1.14.2") ocamlc-loc;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/ocamllsp --prefix PATH : ${dot-merlin-reader}/bin
  '';

  meta = lsp.meta // {
    description = "OCaml Language Server Protocol implementation";
    mainProgram = "ocamllsp";
  };
}
