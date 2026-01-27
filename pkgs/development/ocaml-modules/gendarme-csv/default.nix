{
  lib,
  buildDunePackage,
  ocaml,
  gendarme,
  csv,
  ppx_marshal_ext,
}:

buildDunePackage (finalAttrs: {
  pname = "gendarme-csv";

  inherit (gendarme)
    version
    src
    ;

  minimalOCamlVersion = "4.13";

  propagatedBuildInputs = [
    csv
    ppx_marshal_ext
  ];

  meta = {
    description = "Marshal OCaml data structures to CSV";

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
