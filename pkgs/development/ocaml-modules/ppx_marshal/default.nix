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
    finalAttrs.passthru.deps.ppxlib
  ];

  postInstall = ''
    mkdir -p $out/bin

    ln -s \
      $out/lib/ocaml/${ocaml.version}/site-lib/ppx_marshal/ppx.exe \
      $out/bin/ppx
  '';

  checkInputs = [
    alcotest
  ];

  doCheck = true;

  passthru.deps.ppxlib = ppxlib.override {
    version = "0.34.0";
  };

  meta = {
    description = "Preprocessor extension to automatically define marshallers for OCaml types";
    mainProgram = "ppx";

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
