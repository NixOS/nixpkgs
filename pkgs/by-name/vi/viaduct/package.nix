{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "viaduct";
  version = "0.0.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tonhe";
    repo = "viaduct";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/bj0Khdybgqfyz3qikjk4XbVR7K04Hj7JSfAEHouI7I=";
  };

  vendorHash = "sha256-nKQbx1YciT3w0Nfq2ZvOTWPRSHMsOpDt2M7X7mSk/lY=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.buildVersion=${finalAttrs.src.rev}"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "via --version";
    };
  };

  meta = {
    description = "A modern, terminal-native traceroute tool with real-time ECMP multipath discovery";
    homepage = "https://github.com/tonhe/viaduct";
    changelog = "https://github.com/tonhe/viaduct/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ frantathefranta ];
    mainProgram = "via";
  };
})
