{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wgcf";
  version = "2.2.23";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-zASb21C3GX4wQGf5V5Y+rKwq28S3CDi0gh696lspVnM=";
  };

  subPackages = ".";

  vendorHash = "sha256-ihcIEoVNSPJzJGeH2bRot4fldIhZ0r/yuYU6Jp9F1Eo=";

  meta = with lib; {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage = "https://github.com/ViRb3/wgcf";
    license = licenses.mit;
    maintainers = with maintainers; [ yureien ];
    mainProgram = "wgcf";
  };
}
