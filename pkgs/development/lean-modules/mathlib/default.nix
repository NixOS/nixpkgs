{
  lib,
  buildLakePackage,
  runCommand,
  xz,
  fetchFromGitHub,
  batteries,
  aesop,
  Qq,
  proofwidgets,
  plausible,
  LeanSearchClient,
  importGraph,
  tests,
}:

let
  mathlib__archive = buildLakePackage (finalAttrs: {
    pname = "lean4-mathlib";
    # nixpkgs-update: no auto update
    version = "4.29.1";

    src = fetchFromGitHub {
      owner = "leanprover-community";
      repo = "mathlib4";
      tag = "v${finalAttrs.version}";
      hash = "sha256-K/QPTOytsV+OX25xyKlspeB9G0a28IjmJxcUAKXFP9U=";
    };

    leanPackageName = "mathlib";
    leanDeps = [
      batteries
      aesop
      Qq
      proofwidgets
      plausible
      LeanSearchClient
      importGraph
    ];

    nativeBuildInputs = [ xz ];

    # Compress the installed output into an xz archive so the derivation
    # fits Hydra's max_output_size. The user-facing mathlib derivation
    # decompresses transparently from this archive, at the de minimis
    # compliance cost of nested compression.
    postInstall = ''
      tar cf - -C "$out" . | xz -T0 > "$TMPDIR/archive.tar.xz"
      rm -rf "$out"
      mkdir -p "$out"
      mv "$TMPDIR/archive.tar.xz" "$out/"
    '';

    meta = {
      description = "Mathematical library for Lean 4";
      homepage = "https://github.com/leanprover-community/mathlib4";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ nadja-y ];
    };
  });
in

runCommand mathlib__archive.name
  {
    nativeBuildInputs = [ xz ];
    passthru = {
      inherit mathlib__archive;
      inherit (mathlib__archive)
        src
        version
        lakePackageName
        lean4
        allLeanDeps
        computedLakeDeps
        overrideLakeDepsAttrs
        ;
      tests = {
        inherit (tests.lake) weak-minimax;
      };
    };
    meta = mathlib__archive.meta // {
      hydraPlatforms = [ ];
    };
  }
  ''
    mkdir -p $out
    xz -dT0 < ${mathlib__archive}/archive.tar.xz | tar xf - -C $out
  ''
