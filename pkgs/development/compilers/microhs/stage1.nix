{
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

    makeFlags = [ "PREFIX=${placeholder "out"}" ];
    installTargets = [
      "oldinstall"
    ];

    buildPhase = ''
      runHook preBuild
      mkdir -p bin
      make $makeFlags mhs.conf
      printf 'Building bin/mhs using ${microhs-boot}/bin/mhs\n'
      MHSDIR=. ${microhs-boot}/bin/mhs -l -imhs -isrc -ipaths MicroHs.Main -o bin/mhs
      runHook postBuild
    '';
  }
)
