{
  lib,
  buildDunePackage,
  ocaml,
  gendarme,
  ppx_marshal_ext,
  yojson,
}:

buildDunePackage (finalAttrs: {
  pname = "gendarme-yojson";

  inherit (gendarme)
    version
    src
    ;

  minimalOCamlVersion = "4.13";

  propagatedBuildInputs = [
    ppx_marshal_ext
    yojson
  ];

  meta = {
    description = "Marshal OCaml data structures to JSON using Yojson";

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
