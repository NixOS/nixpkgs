{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tlsinfo";
  version = "0.1.54";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "tlsinfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RMmYlTcQaf1HrP+d5VttosHr5BrNwsbUst8AptpkFTs=";
  };

  vendorHash = "sha256-rUvveQ82WHtmiRNE/sKACami5YdGw4y4BEdnsfbwVW4=";

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
