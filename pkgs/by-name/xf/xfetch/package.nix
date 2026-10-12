{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xfetch";
  version = "1.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "xfetch-cli";
    repo = "xfetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f6MiZnMcr+gV631auVgb+BG9xozWF94bXmvszlZeHwQ=";
  };

  cargoHash = "sha256-9s78bJZxOZ3k8nl3Dcgt3/xPOgqTgIVDJTFOZkZvfy0=";

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Fast, customizable system information fetch tool for the terminal";
    homepage = "https://github.com/xfetch-cli/xfetch";
    changelog = "https://github.com/xfetch-cli/xfetch/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "xfetch";
    maintainers = with lib.maintainers; [ xscriptor ];
    platforms = lib.platforms.all;
  };
})
