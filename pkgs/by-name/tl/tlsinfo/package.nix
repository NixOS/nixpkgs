{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tlsinfo";
  version = "0.1.53";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "tlsinfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZP9juaZ2jsXSnvz1RxJ/841QgYvSYupdG2OqOOm55U4=";
  };

  vendorHash = "sha256-rxTiIGIdSSwS1UdBjWmNz5iUlkUb1htDCa5XRpFLUw8=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/paepckehh/tlsinfo/releases/tag/v${finalAttrs.version}";
    homepage = "https://paepcke.de/tlsinfo";
    description = "Tool to analyze and troubleshoot TLS connections";
    license = lib.licenses.bsd3;
    mainProgram = "tlsinfo";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})
