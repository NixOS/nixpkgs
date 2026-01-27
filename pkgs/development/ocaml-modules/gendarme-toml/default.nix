{
  lib,
  buildDunePackage,
  ocaml,
  gendarme,
  ppx_marshal_ext,
  toml,
}:

buildDunePackage (finalAttrs: {
  pname = "gendarme-toml";

  inherit (gendarme)
    version
    src
    ;

  minimalOCamlVersion = "4.13";

  propagatedBuildInputs = [
    ppx_marshal_ext
    toml
  ];

  meta = {
    description = "Marshal OCaml data structures to TOML";

    inherit (gendarme.meta)
      homepage
      changelog
      license
      platforms
      maintainers
      teams
      ;

    broken = lib.versionAtLeast ocaml.version "5.4";
  };
})
