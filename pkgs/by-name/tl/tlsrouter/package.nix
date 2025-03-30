{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule {
  pname = "tlsrouter";
  version = "0-unstable-2025-02-22";

  src = fetchFromGitHub {
    owner = "inetaf";
    repo = "tcpproxy";
    rev = "c4b9df066048ad2ab5c32235362fa94444a24ebe";
    hash = "sha256-N/kdZ1esDnEaboDLU/WjXftA0a2PcOFnxDfojSYXyNQ=";
  };

  vendorHash = "sha256-AFgBQsufrJhfMnbSAOyfgSK6StMix0zKvsRJJx4jmtY=";

  subPackages = [ "cmd/tlsrouter" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "TLSRouter is a TLS proxy that routes connections to backends based on the TLS SNI (Server Name Indication) of the TLS handshake.";
    homepage = "https://github.com/inetaf/tcpproxy";
    mainProgram = "tlsrouter";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.xsteadfastx ];
    platforms = lib.platforms.unix;
  };
}
