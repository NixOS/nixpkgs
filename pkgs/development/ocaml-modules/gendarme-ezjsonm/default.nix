{
  lib,
  buildDunePackage,
  ocaml,
  gendarme,
  ezjsonm,
  ppx_marshal_ext,
}:

buildDunePackage (finalAttrs: {
  pname = "gendarme-ezjsonm";

  inherit (gendarme)
    version
    src
    ;

  minimalOCamlVersion = "4.13";

  propagatedBuildInputs = [
    ezjsonm
    ppx_marshal_ext
  ];

  meta = {
    description = "Marshal OCaml data structures to JSON using Ezjsonm";

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
