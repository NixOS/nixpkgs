{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  testers,
  whosthere,
}:

buildGoModule (finalAttrs: {
  pname = "whosthere";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ramonvermeulen";
    repo = "whosthere";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-jwXJ+mF3r+Xg3lyQzwzfGp3TmfVjnxO9Lg272zeTREY=";
  };

  vendorHash = "sha256-ZiomQ+Md0kFkq7nERsnLZwkA9nlcvglMtzJV7NX3Igs=";

  checkFlags =
    let
      # Skip tests that require filesystem access
      skippedTests = [
        "TestResolveLogPath"
        "TestStateDir"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  passthru.updateScript = nix-update-script { };
  passthru.tests.version = testers.testVersion { package = whosthere; };

  meta = {
    description = "Local Area Network discovery tool";
    longDescription = ''
      Local Area Network discovery tool with a modern Terminal User Interface
      (TUI) written in Go. Discover, explore, and understand your LAN in an
      intuitive way. Knock Knock.. who's there?
    '';
    homepage = "https://github.com/ramonvermeulen/whosthere";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.linux;
    mainProgram = "whosthere";
  };
})
