{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wgcf";
  version = "2.2.30";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo = "wgcf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZiVSbsudGnwV7IkhUltzeC4EjTxWIaxvmxBiMcMYAfQ=";
  };

  subPackages = ".";

  vendorHash = "sha256-nEUupbb918KQrJaeSHWB/jxRtM/pD6Fjzib4y/GtnVc=";

  meta = {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage = "https://github.com/ViRb3/wgcf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yureien ];
    mainProgram = "wgcf";
  };
})
