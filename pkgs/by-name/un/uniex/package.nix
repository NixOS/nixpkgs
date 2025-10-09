{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "uniex";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "uniex";
    tag = "v${version}";
    hash = "sha256-+wcAm3UFRs70HJ64emuWNnyroUhFHUPsaMQPCaMAexg=";
  };

  vendorHash = "sha256-s/oWtYziUtSKDQmvDxWznqynlKmWxwt5jAAT5xl+gqo=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/paepckehh/uniex/releases/tag/v${version}";
    homepage = "https://paepcke.de/uniex";
    description = "Unifi controller device inventory exporter, analyses all device and stat records for complete records";
    license = lib.licenses.bsd3;
    mainProgram = "uniex";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}
