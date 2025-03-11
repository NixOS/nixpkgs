{
  lib,
  buildGoModule,
  gitUpdater,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "uniex";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "uniex";
    tag = "v${version}";
    hash = "sha256-LakiFi+4uYaDsLWAq4VXDoZMQU5MRLdFmsdBOglubzQ=";
  };

  vendorHash = "sha256-QLjeMSdvFSxnmnsKwTg4SDkc7xqx4csxTWJKOsRzcBI=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    changelog = "https://github.com/paepckehh/uniex/releases/tag/v${version}";
    homepage = "https://paepcke.de/uniex";
    description = "Tool to export unifi network controller mongodb asset information [csv|json].";
    license = lib.licenses.bsd3;
    mainProgram = "uniex";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}
