{
  lib,
  buildNpmPackage,
  fetchurl,
  nodejs_22,
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

  meta = {
    description = "Declarative SVG compiler, transactional installer, and drift checker";
    homepage = "https://github.com/Knowledge-Forge-AI/theme-forge-stellar-burst";
    license = lib.licenses.agpl3Plus;
    mainProgram = "tfsb";
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
})
