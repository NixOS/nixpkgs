{
  args,
  cpphs,
  microcabal-stage1,
  microhs-stage1,
  stdenv,
  callPackage,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    args' = args finalAttrs;
    haskellCompilerName = "mhs-${args'.version}";
  in
  args'
  // {
    pname = "microhs";

    nativeBuildInputs = [
      microcabal-stage1
      microhs-stage1
    ];

    env = {
      CABALDIR = "${placeholder "out"}/lib/mcabal";
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      pushd lib
      mcabal -v install
      popd
      mcabal -v install

      mkdir -p $out/bin
      ln -s ../lib/mcabal/bin/mhs $out/bin/mhs

      runHook postInstall
    '';

    passthru = {
      inherit
        haskellCompilerName
        cpphs
        microcabal-stage1
        microhs-stage1
        ;
      targetPrefix = "";
      isMhs = true;
      isHugs = false;

      tests = {
        hello-world = callPackage ./test-hello-world.nix { microhs = finalAttrs.finalPackage; };
      };
    };
  }
)
