{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wgcf";
  version = "2.2.32";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo = "wgcf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SZBDdN1SgMVoPlsv7iopeDdUArYlnRtQG1hbcRr6vac=";
  };

  subPackages = ".";

  vendorHash = "sha256-NqFZzrV+1BN2zPVBO3V/sr2AEQVtuYbzqqZgF0r1tFU=";

  meta = {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage = "https://github.com/ViRb3/wgcf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yureien ];
    mainProgram = "wgcf";
  };
})
