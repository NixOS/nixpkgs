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
    finalAttrs.passthru.deps.ppxlib
  ];

  passthru.deps.ppxlib = ppxlib.override {
    version = "0.34.0";
  };

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

    broken = lib.versionAtLeast ocaml.version "5.4";
  };
})
