{
  lib,
  buildLakePackage,
  runCommand,
  leangz,
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
  # build leangz without zstd support, to improve Hydra's xz compression ratio
  leangz-raw = leangz.overrideAttrs { cargoBuildNoDefaultFeatures = true; };

  mathlib__archive = buildLakePackage (finalAttrs: {
    pname = "lean4-mathlib";
    # nixpkgs-update: no auto update
    version = "4.30.0";

    src = fetchFromGitHub {
      owner = "leanprover-community";
      repo = "mathlib4";
      tag = "v${finalAttrs.version}";
      hash = "sha256-RxOxdUiVUAxUbfVhxlkjmPX1V64EtmIIn1eW75TiJWA=";
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

    nativeBuildInputs = [ leangz-raw ];

    # Per-module lgz preprocessing strips olean structural overhead,
    # providing significant compression benefit over a raw xz invocation.
    # This also brings the output under Hydra's max_output_size. The
    # user-facing mathlib derivation unpacks transparently.
    postInstall = ''
      local lib="$out/.lake/build/lib/lean"
      local ir="$out/.lake/build/ir"
      find "$lib" -name '*.trace' -print0 \
        | xargs -0 -P"$NIX_BUILD_CORES" -I{} bash -c '
            base="''${1%.trace}"; rel="''${base#'"$lib"'/}"
            leantar -C "'"$lib"'" -C "'"$ir"'" "$base.ltar" \
              "$rel.trace" "$rel.olean" "$rel.olean.server" "$rel.olean.private" \
              "$rel.ilean" -i 1 "$rel.c"
            rm "$base".{trace,olean,olean.server,olean.private,ilean} "'"$ir"'/$rel.c"
          ' _ {}
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
    nativeBuildInputs = [ leangz-raw ];
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
    cp -rT ${mathlib__archive} $out
    chmod -R u+w $out
    find $out/.lake/build/lib -name '*.ltar' \
      -exec leantar -C $out/.lake/build/lib/lean -C $out/.lake/build/ir -x {} +
    find $out/.lake/build/lib -name '*.ltar' -delete
  ''
