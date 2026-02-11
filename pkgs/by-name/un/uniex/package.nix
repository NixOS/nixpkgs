{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "uniex";
  version = "0.1.28";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "uniex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9/B6SVPvHT7l8Y5rY7ax09B30ra3doCUDCtTZUgwcZo=";
  };

  vendorHash = "sha256-YZ4WbKSa3hFVqIkZGye0UN5WSezPuAPdNdcA5opaWi4=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/paepckehh/uniex/releases/tag/v${finalAttrs.version}";
    homepage = "https://paepcke.de/uniex";
    description = "Unifi controller device inventory exporter, analyses all device and stat records for complete records";
    license = lib.licenses.bsd3;
    mainProgram = "uniex";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})
