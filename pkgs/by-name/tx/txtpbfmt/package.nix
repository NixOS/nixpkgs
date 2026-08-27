{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "txtpbfmt";
  version = "0-unstable-2026-08-03";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "txtpbfmt";
    rev = "1fd8a60d1ffc4b3893ee1b4b8d7a4bf7c15489a0";
    hash = "sha256-AvLCcgY5cQy8ZOzD7u76T40IJ2owX+P36L+w495bqGE=";
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
