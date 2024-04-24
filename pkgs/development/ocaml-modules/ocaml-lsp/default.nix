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
, merlin-lib
, astring
, camlp-streams
}:

buildDunePackage rec {
  pname = "ocaml-lsp-server";
  inherit (lsp) version src preBuild;
  duneVersion = "3";

  buildInputs = lsp.buildInputs ++ [ lsp re ]
  ++ lib.optional (lib.versionAtLeast version "1.9") spawn
  ++ lib.optionals (lib.versionAtLeast version "1.10") [ fiber xdg ]
  ++ lib.optional (lib.versionAtLeast version "1.14.2") ocamlc-loc
  ++ lib.optionals (lib.versionAtLeast version "1.17.0") [ astring camlp-streams merlin-lib ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/ocamllsp --prefix PATH : ${dot-merlin-reader}/bin
  '';

  meta = lsp.meta // {
    description = "OCaml Language Server Protocol implementation";
    mainProgram = "ocamllsp";
  };
}
