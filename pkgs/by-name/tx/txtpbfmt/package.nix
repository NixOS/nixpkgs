{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "txtpbfmt";
  version = "0-unstable-2026-10-13";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "txtpbfmt";
    rev = "7c8a61a7a736d9960cbc1142c7c0f6f4495dd323";
    hash = "sha256-zisMN/RcMkv/GUkG4TLlC+5v9PLcnu/Wd6W3ZdlDXQw=";
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
