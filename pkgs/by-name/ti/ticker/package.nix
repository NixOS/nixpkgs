{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ticker,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "ticker";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = "ticker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GH+2as3aK462cTguGekbB4HchVzC1HdBsXwJHwAh47Q=";
  };

  vendorHash = "sha256-EKc9QRDSOD4WetCXORjMUlaFqh0+B3Aa3m5SR1WiKN4=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/achannarasappa/ticker/v${lib.versions.major finalAttrs.version}/cmd.Version=${finalAttrs.version}"
  ];

  # Tests require internet
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = ticker;
    command = "ticker --version";
    inherit (finalAttrs) version;
  };

  meta = {
    description = "Terminal stock ticker with live updates and position tracking";
    homepage = "https://github.com/achannarasappa/ticker";
    changelog = "https://github.com/achannarasappa/ticker/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      siraben
      sarcasticadmin
    ];
    mainProgram = "ticker";
  };
})
