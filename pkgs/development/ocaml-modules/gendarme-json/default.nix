{
  lib,
  buildDunePackage,
  ocaml,
  gendarme,
}:

buildDunePackage (finalAttrs: {
  pname = "gendarme-json";

  inherit (gendarme)
    version
    src
    ;

  minimalOCamlVersion = "4.13";

  meta = {
    description = "Metapackage for JSON marshalling using Gendarme";

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
