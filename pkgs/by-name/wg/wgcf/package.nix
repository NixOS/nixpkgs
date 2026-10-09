{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wgcf";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo = "wgcf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zBU34dKCmXCo7e5Xsl7pDX0XsRIt9rmGWXRa46A2/2E=";
  };

  subPackages = ".";

  vendorHash = "sha256-tQlQrad4YsbwkegxxoKw0YAg4qDS2SxW+KenLF3FyHc=";

  meta = {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage = "https://github.com/ViRb3/wgcf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yureien ];
    mainProgram = "wgcf";
  };
})
