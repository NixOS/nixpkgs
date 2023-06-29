{ lib, callPackage, ocaml-ng, version ? "0.25.1" }:

with ocaml-ng.ocamlPackages;

let inherit (callPackage ./generic.nix { inherit version; }) src library_deps;

in assert (lib.versionAtLeast version "0.25.1");

buildDunePackage {
  pname = "ocamlformat-lib";
  inherit src version;

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  nativeBuildInputs = [ menhir ];

  propagatedBuildInputs = library_deps;

  meta = {
    homepage = "https://github.com/ocaml-ppx/ocamlformat";
    description = "Auto-formatter for OCaml code (library)";
    maintainers = with lib.maintainers; [ Zimmi48 marsam Julow ];
    license = lib.licenses.mit;
  };
}
