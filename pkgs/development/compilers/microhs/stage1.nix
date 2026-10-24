{
  lib,
  args,
  microhs-boot,
  stdenv,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    args' = args finalAttrs;
  in
  args'
  // {
    pname = "microhs-stage1";
    patches =
      (args'.patches or [ ])
      ++ lib.optionals microhs-boot.usesHugs [
        patches/simple-unicode.patch
      ];

    makeFlags = [ "PREFIX=${placeholder "out"}" ];
    installTargets = [
      "oldinstall"
    ];

    buildPhase = ''
      runHook preBuild
      mkdir -p bin
      printf 'Building bin/mhs using ${microhs-boot}/bin/mhs\n'
      ${microhs-boot}/bin/mhs -l -imhs -isrc -ipaths MicroHs.Main -o bin/mhs
      runHook postBuild
    '';
  }
)
