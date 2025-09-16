{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ticker,
  testers,
}:

buildGoModule rec {
  pname = "ticker";
  version = "5.0.6";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = "ticker";
    tag = "v${version}";
    hash = "sha256-sm/57kOiFI+mAH3VNAklXeTaZqfuJSZmLYXvj8cZQso=";
  };

  vendorHash = "sha256-EKc9QRDSOD4WetCXORjMUlaFqh0+B3Aa3m5SR1WiKN4=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/achannarasappa/ticker/v${lib.versions.major version}/cmd.Version=${version}"
  ];

  # Tests require internet
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = ticker;
    command = "ticker --version";
    inherit version;
  };

  meta = {
    description = "Terminal stock ticker with live updates and position tracking";
    homepage = "https://github.com/achannarasappa/ticker";
    changelog = "https://github.com/achannarasappa/ticker/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      siraben
      sarcasticadmin
    ];
    mainProgram = "ticker";
  };
}
