{
  lib,
  buildNpmPackage,
  fetchurl,
  nodejs_22,
  python3,
  runCommand,
}:

buildNpmPackage (finalAttrs: {
  pname = "theme-forge-stellar-burst";
  version = "0.5.0";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/Knowledge-Forge-AI/theme-forge-stellar-burst/releases/download/v0.5.0/theme-forge-stellar-burst-staging.tar.gz";
    hash = "sha256-ovSqJmxoFqdKuUgYizxOl7k9H6WJiZTdJh/mm1a+4AY=";
  };

  sourceRoot = ".";
  npmDepsHash = "sha256-5hyNwijmS6geMsd1ASkw/GHZ3xUx5R6OjweLKzZBjxU=";
  nodejs = nodejs_22;
  npmFlags = [ "--ignore-scripts" ];
  npmBuildScript = "build";

  passthru.tests.smoke =
    runCommand "${finalAttrs.pname}-smoke"
      {
        __structuredAttrs = true;
        strictDeps = true;
        nativeBuildInputs = [ python3 ];
      }
      ''
        export HOME="$TMPDIR/home"
        mkdir -p "$HOME"
        python ${./smoke-test.py} ${finalAttrs.finalPackage} ${nodejs_22}/bin/node
        touch "$out"
      '';

  meta = {
    description = "Declarative SVG compiler, transactional installer, and drift checker";
    homepage = "https://github.com/Knowledge-Forge-AI/theme-forge-stellar-burst";
    changelog = "https://github.com/Knowledge-Forge-AI/theme-forge-stellar-burst/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.lair001 ];
    # TypeScript is built here; the release also includes native snapshot addons.
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    mainProgram = "tfsb";
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
})
