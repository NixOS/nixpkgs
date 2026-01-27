{
  lib,
  buildDunePackage,
  ocaml,
  ppxlib,
  gendarme,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_marshal_ext";

  inherit (gendarme)
    version
    src
    ;

  minimalOCamlVersion = "4.13";

  propagatedBuildInputs = [
    gendarme
    ppxlib
  ];

  meta = {
    description = "Preprocessor extension to simplify writing Gendarme encoders";

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
