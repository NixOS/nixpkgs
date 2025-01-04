{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  termshot,
  nix-update-script,
}:
buildGoModule rec {
  pname = "termshot";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "homeport";
    repo = "termshot";
    tag = "v${version}";
    hash = "sha256-vvSUdXVLuc3GmxPX9SzSeb8vbmqjhSLjXd9nmU7Q46g=";
  };

  vendorHash = "sha256-nXAIU07SY/GdWZGASHXDg36cSGKw4elLOBDCoJk/xlU=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/homeport/termshot/internal/cmd.version=${version}"
  ];

  passthru = {
    tests.version = testers.testVersion { package = termshot; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Creates screenshots based on terminal command output";
    homepage = "https://github.com/homeport/termshot";
    changelog = "https://github.com/homeport/termshot/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "termshot";
  };
}
