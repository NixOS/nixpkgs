{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wgcf";
  version = "2.2.24";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-BtZvR+dZzauByQR5+VWzh6tOgAQV1sXfr0ThOy05uRo=";
  };

  subPackages = ".";

  vendorHash = "sha256-txE00e8n9JJ89G1Exp/k8LTv36+MkGduCjqL7mHXuoQ=";

  meta = with lib; {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage = "https://github.com/ViRb3/wgcf";
    license = licenses.mit;
    maintainers = with maintainers; [ yureien ];
    mainProgram = "wgcf";
  };
}
