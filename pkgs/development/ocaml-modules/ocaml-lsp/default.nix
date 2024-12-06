{ lib
, ocaml
, buildDunePackage
, lsp
, xdg
, re
, fiber
, makeWrapper
, dot-merlin-reader
, spawn
, ocamlc-loc
, merlin
, merlin-lib
, astring
, camlp-streams
, base
}:

# Freeze ocaml-lsp-version at 1.17.0 for OCaml 5.0
#  for which merlin 4.16 is not available
let lsp_v =
  if lib.versions.majorMinor ocaml.version == "5.0"
  then lsp.override { version = "1.17.0"; }
  else lsp
; in

let lsp = lsp_v; in

# Use merlin < 4.17 for OCaml < 5.2
let merlin-lib_v =
  if lib.versions.majorMinor ocaml.version == "4.14"
  then merlin-lib.override {
    merlin = merlin.override {
      version = "4.16-414";
    };
  } else if lib.versions.majorMinor ocaml.version == "5.1"
  then merlin-lib.override {
    merlin = merlin.override {
      version = "4.16-501";
    };
  } else merlin-lib
; in
let merlin-lib = merlin-lib_v; in

buildDunePackage rec {
  pname = "ocaml-lsp-server";
  inherit (lsp) version src preBuild;

  buildInputs = lsp.buildInputs ++ [ lsp re ]
  ++ lib.optional (lib.versionAtLeast version "1.9") spawn
  ++ lib.optionals (lib.versionAtLeast version "1.10") [ fiber xdg ]
  ++ lib.optional (lib.versionAtLeast version "1.14.2") ocamlc-loc
  ++ lib.optionals (lib.versionAtLeast version "1.17.0") [ astring camlp-streams merlin-lib ]
  ++ lib.optional (lib.versionAtLeast version "1.18.0") base
  ;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/ocamllsp --prefix PATH : ${dot-merlin-reader}/bin
  '';

  meta = lsp.meta // {
    description = "OCaml Language Server Protocol implementation";
    mainProgram = "ocamllsp";
  };
}
