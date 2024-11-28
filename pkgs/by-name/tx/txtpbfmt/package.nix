{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "txtpbfmt";
  version = "0-unstable-2024-11-12";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "txtpbfmt";
    rev = "20d2c9ebc01daa87ca2b7b697a757613012b104d";
    hash = "sha256-gCGJQldwTa6Lq7Fvc4NAVRpmMs204qeKEsNFEjErTMA=";
  };

  vendorHash = "sha256-IdD+R8plU4/e9fQaGSM5hJxyMECb6hED0Qg8afwHKbY=";

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
