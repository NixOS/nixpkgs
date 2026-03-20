{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "txtpbfmt";
  version = "0-unstable-2026-02-17";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "txtpbfmt";
    rev = "a481f6a22f9426d6c2cc3d4be185b28d156886e4";
    hash = "sha256-5dX1hEq1VzzZdXaoxkyy/gCbB8u/wlwy8g9kScVmJZs=";
  };

  vendorHash = "sha256-aeYa7a/oKH2dxXHRkkqyh7f04citRDGQxAaKQTJst4o=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Formatter for text proto files";
    homepage = "https://github.com/protocolbuffers/txtpbfmt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "txtpbfmt";
  };
}
