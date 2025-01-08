{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ticker";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-L7vqZVfj7Ns8xCFU0ruhosReM4RMhIbIHXrMbQ8YI6I=";
  };

  vendorHash = "sha256-o3hVRHyrJpmYgephoZ2JlVLGSqZtRQAp48OzoIMY3do=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/achannarasappa/ticker/cmd.Version=v${version}"
  ];

  # Tests require internet
  doCheck = false;

  meta = with lib; {
    description = "Terminal stock ticker with live updates and position tracking";
    homepage = "https://github.com/achannarasappa/ticker";
    changelog = "https://github.com/achannarasappa/ticker/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      siraben
      sarcasticadmin
    ];
    mainProgram = "ticker";
  };
}
