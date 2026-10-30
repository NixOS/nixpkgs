{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  coreutils,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xfetch";
  version = "1.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "xfetch-cli";
    repo = "xfetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5RBo7T/56ii/NjBi451sh49QXuelNCabxXhPrqjy50c=";
  };

  cargoHash = "sha256-6P8G57PNGMjEooEenx3M0YnMx4EKnI7WzUZqJ3Zs2Bk=";

  nativeCheckInputs = [ coreutils ];

  preCheck = ''
    export HOME="$TMPDIR"
    export XDG_CACHE_HOME="$TMPDIR/.cache"
    export XDG_CONFIG_HOME="$TMPDIR/.config"
  '';

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
