{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ticker,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "ticker";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = "ticker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1q+TMCYPp9AicWJZzWrrr5ukj6AcckNkp2yP4NyOm5g=";
  };

  vendorHash = "sha256-kEyZMFW1ex45yC4G9qZUOeXVdQKjcExG7hKvN8lxrDI=";

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
