{ lib
, callPackage
, buildDunePackage
, ocaml
, re
, ocamlformat-lib
, menhir
, version ? "0.26.0"
}:

let inherit (callPackage ./generic.nix { inherit version; }) src library_deps;
in

lib.throwIf (lib.versionAtLeast ocaml.version "5.0" && !lib.versionAtLeast version "0.23")
  "ocamlformat ${version} is not available for OCaml ${ocaml.version}"

buildDunePackage {
  pname = "ocamlformat";
  inherit src version;

  minimalOCamlVersion = "4.08";

  nativeBuildInputs =
    if lib.versionAtLeast version "0.25.1" then [ ] else [ menhir ];

  buildInputs = [ re ] ++ library_deps
    ++ lib.optionals (lib.versionAtLeast version "0.25.1")
    [ (ocamlformat-lib.override { inherit version; }) ];

  meta = {
    homepage = "https://github.com/ocaml-ppx/ocamlformat";
    description = "Auto-formatter for OCaml code";
    maintainers = with lib.maintainers; [ Zimmi48 marsam Julow ];
    license = lib.licenses.mit;
    mainProgram = "ocamlformat";
  };
}
