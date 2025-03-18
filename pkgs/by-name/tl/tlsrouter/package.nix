{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule {
  pname = "tlsrouter";
  version = "0-unstable-2026-09-22";

  src = fetchFromGitHub {
    owner = "inetaf";
    repo = "tcpproxy";
    rev = "c159a60511096e475e3489ce13ae57e752c78f99";
    hash = "sha256-414PJnfDIHEJJH0CAiegMrM0ehsLyW3g/4afzsjdJX8=";
  };

  vendorHash = "sha256-AFgBQsufrJhfMnbSAOyfgSK6StMix0zKvsRJJx4jmtY=";

  subPackages = [ "cmd/tlsrouter" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  __structuredAttrs = true;

  meta = {
    description = "TLSRouter is a TLS proxy that routes connections to backends based on the TLS SNI (Server Name Indication) of the TLS handshake.";
    homepage = "https://github.com/inetaf/tcpproxy";
    mainProgram = "tlsrouter";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.xsteadfastx ];
    platforms = lib.platforms.unix;
  };
}
