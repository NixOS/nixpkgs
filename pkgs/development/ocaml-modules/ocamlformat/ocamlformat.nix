# Version can be selected with the 'version' argument, see generic.nix.
{
  lib,
  callPackage,
  buildDunePackage,
  ocaml,
  re,
  ocamlformat-lib,
  menhir,
  ...
}@args:

let
  inherit (callPackage ./generic.nix args) src version library_deps;
in
buildDunePackage {
  pname = "ocamlformat";
  inherit src version;

  minimalOCamlVersion = "4.08";

  nativeBuildInputs = if lib.versionAtLeast version "0.25.1" then [ ] else [ menhir ];

  buildInputs = [
    re
  ]
  ++ library_deps
  ++ lib.optionals (lib.versionAtLeast version "0.25.1") [
    (ocamlformat-lib.override { inherit version; })
  ];

  meta = {
    homepage = "https://github.com/ocaml-ppx/ocamlformat";
    description = "Auto-formatter for OCaml code";
    maintainers = with lib.maintainers; [
      Zimmi48
      Julow
    ];
    license = lib.licenses.mit;
    mainProgram = "ocamlformat";
    broken =
      lib.versionAtLeast ocaml.version "5.0" && !lib.versionAtLeast version "0.23"
      || lib.versionAtLeast ocaml.version "5.1" && !lib.versionAtLeast version "0.25"
      || lib.versionAtLeast ocaml.version "5.2" && !lib.versionAtLeast version "0.26.2"
      || lib.versionAtLeast ocaml.version "5.3" && !lib.versionAtLeast version "0.27"
      || lib.versionAtLeast ocaml.version "5.4" && !lib.versionAtLeast version "0.28";
  };
}
