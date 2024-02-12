{ lib
, buildDunePackage
, lsp
, xdg
, re
, fiber
, makeWrapper
, dot-merlin-reader
, spawn
, ocamlc-loc
, odoc-parser
, merlin-lib
}:

buildDunePackage rec {
  pname = "ocaml-lsp-server";
  inherit (lsp) version src preBuild;
  duneVersion = "3";

  buildInputs = lsp.buildInputs ++ [ lsp re ]
  ++ lib.optional (lib.versionAtLeast version "1.9") spawn
  ++ lib.optionals (lib.versionAtLeast version "1.10") [ fiber xdg ]
  ++ lib.optional (lib.versionAtLeast version "1.14.2") ocamlc-loc
  ++ lib.optional (lib.versionAtLeast version "1.16.2") [ odoc-parser merlin-lib ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/ocamllsp --prefix PATH : ${dot-merlin-reader}/bin
  '';

  meta = lsp.meta // {
    description = "OCaml Language Server Protocol implementation";
    mainProgram = "ocamllsp";
  };
}
