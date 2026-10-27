{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wgcf";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo = "wgcf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NfdVtfZ9W3RTTRX72w7xbhl55QTW/U205wfuFE1OifE=";
  };

  subPackages = ".";

  vendorHash = "sha256-B8D/G2oxBlCcAxt0L38Z7s3YxC3sXRdSzoobGN2m+jk=";

  meta = {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage = "https://github.com/ViRb3/wgcf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yureien ];
    mainProgram = "wgcf";
  };
})
