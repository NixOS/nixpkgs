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

    backcompatPatch =
      v:
      lib.optional (
        lib.versionAtLeast args'.version v && lib.versionOlder microhs-boot.version v
      ) patches/backcompat-${v}.patch;
  in
  args'
  // {
    pname = "microhs-stage1";
    patches =
      (args'.patches or [ ])
      ++ lib.optional microhs-boot.isHugs patches/simple-unicode.patch
      ++ backcompatPatch "0.14.20.0"
      ++ backcompatPatch "0.14.21.0";

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
