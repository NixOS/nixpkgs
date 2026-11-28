{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tlsinfo";
  version = "0.1.72";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "tlsinfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Go9W/HzTF1EiMnCu/XfLgXhRxFh6y09Yg1UbL06GFTs=";
  };

  vendorHash = "sha256-V5hsBuZptx4Lf8rBDUcX4dDVEFCVo3EdETAdpuw8PeE=";

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
