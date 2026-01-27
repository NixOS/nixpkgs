{
  lib,
  buildDunePackage,
  ocaml,
  gendarme,
  ppx_marshal_ext,
  yaml,
}:

buildDunePackage (finalAttrs: {
  pname = "gendarme-yaml";

  inherit (gendarme)
    version
    src
    ;

  minimalOCamlVersion = "4.13";

  propagatedBuildInputs = [
    ppx_marshal_ext
    yaml
  ];

  meta = {
    description = "Marshal OCaml data structures to YAML";

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
