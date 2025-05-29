{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ticker,
  testers,
}:

buildGoModule rec {
  pname = "ticker";
  version = "5.0.5";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-SwQkoviJCPJmz//EIBRqvaWtg65xgTo98VnoiciwKHY=";
  };

  vendorHash = "sha256-XKl4bGWTz3AKl+hLFY0R0uT5ryOCHNzoeVHczMb32zo=";

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
