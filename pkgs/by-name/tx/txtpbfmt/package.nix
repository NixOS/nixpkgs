{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "txtpbfmt";
  version = "0-unstable-2025-11-24";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "txtpbfmt";
    rev = "fcb97cc64c7b79be3b13acde32afe2e1ab7563cf";
    hash = "sha256-cDNMMAEYOqEjX9UFX13YfGMZJFfwaaqkgpXkCvFx/L8=";
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
