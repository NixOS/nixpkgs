{
  lib,
  buildDunePackage,
  gendarme,
  gendarme-csv,
  gendarme-ezjsonm,
  gendarme-toml,
  gendarme-yaml,
  gendarme-yojson,
  ocaml,
  ppxlib,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_marshal";

  inherit (gendarme)
    version
    src
    ;

  minimalOCamlVersion = "4.13";

  buildInputs = [
    gendarme
    gendarme-csv
    gendarme-ezjsonm
    gendarme-toml
    gendarme-yaml
    gendarme-yojson
    ppxlib
  ];

  checkInputs = [
    alcotest
  ];

  doCheck = true;

  meta = {
    description = "Preprocessor extension to automatically define marshallers for OCaml types";

    inherit (gendarme.meta)
      homepage
      changelog
      license
      platforms
      maintainers
      teams
      ;
  };
})
