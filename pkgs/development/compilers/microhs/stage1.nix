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
      ++ lib.optional microhs-boot.isHugs patches/simple-unicode.patch
      ++
        lib.optionals
          (lib.versionAtLeast args'.version "0.14.20.0" && lib.versionOlder microhs-boot.version "0.14.20.0")
          [
            patches/backcompat-0.14.20.0.patch
          ];

    makeFlags = [ "PREFIX=${placeholder "out"}" ];
    installTargets = [ "oldinstall" ];

    buildPhase = ''
      runHook preBuild
      mkdir -p bin
      printf 'Building bin/mhs using ${microhs-boot}/bin/mhs\n'
      ${microhs-boot}/bin/mhs -l -imhs -isrc -ipaths MicroHs.Main -o bin/mhs
      runHook postBuild
    '';
  }
)
