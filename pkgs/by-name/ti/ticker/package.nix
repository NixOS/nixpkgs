{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ticker,
  testers,
}:

buildGoModule rec {
  pname = "ticker";
  version = "4.8.1";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-2qg7/gzogvK8eIj9NzFELoeXrtJGC5pS4LvR2msOuHY=";
  };

  vendorHash = "sha256-o3hVRHyrJpmYgephoZ2JlVLGSqZtRQAp48OzoIMY3do=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/achannarasappa/ticker/v4/cmd.Version=${version}"
  ];

  # Tests require internet
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = ticker;
    command = "ticker --version";
    inherit version;
  };

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
