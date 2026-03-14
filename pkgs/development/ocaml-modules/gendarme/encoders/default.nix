{
  lib,
  buildDunePackage,
  callPackage,

  gendarme,
  ocaml,

  type,
}:

assert lib.elem type [
  "csv"
  "ezjsonm"
  "json"
  "toml"
  "yaml"
  "yojson"
];

let
  root = ./.;

  mkGendarmeEncoder =
    {
      buildInputs ? [ ],
      nativeBuildInputs ? [ ],
      propagatedBuildInputs ? [ ],
      meta ? { },
      ...
    }@args:
    buildDunePackage (finalAttrs: {
      pname = "gendarme-${type}";

      inherit (gendarme)
        version
        src
        ;

      minimalOCamlVersion = "4.13";

      inherit
        buildInputs
        nativeBuildInputs
        propagatedBuildInputs
        ;

      meta = {
        inherit (gendarme.meta)
          homepage
          changelog
          license
          platforms
          maintainers
          teams
          ;

        broken = lib.versionAtLeast ocaml.version "5.4";
      }
      // meta;
    });
in
callPackage (root + "/${type}") {
  inherit mkGendarmeEncoder;
}
