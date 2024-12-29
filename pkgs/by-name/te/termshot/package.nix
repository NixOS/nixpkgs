{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "termshot";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "homeport";
    repo = "termshot";
    rev = "v${version}";
    hash = "sha256-vvSUdXVLuc3GmxPX9SzSeb8vbmqjhSLjXd9nmU7Q46g=";
  };

  vendorHash = "sha256-nXAIU07SY/GdWZGASHXDg36cSGKw4elLOBDCoJk/xlU=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/homeport/termshot/internal/cmd.version=${version}"
  ];

  meta = {
    description = "Creates screenshots based on terminal command output";
    homepage = "https://github.com/homeport/termshot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "termshot";
  };
}
