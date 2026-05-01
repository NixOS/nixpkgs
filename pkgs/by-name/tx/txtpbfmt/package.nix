{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "txtpbfmt";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "txtpbfmt";
    rev = "c39628bde8b5d6b6e8f67f46580b5c1dd491b1fd";
    hash = "sha256-D3yONCvyynXKVyeRypllKNMgPgo1w1ObPcra3r7aSF0=";
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
