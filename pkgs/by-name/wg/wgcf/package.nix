{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wgcf";
  version = "2.2.28";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo = "wgcf";
    tag = "v${version}";
    hash = "sha256-Xl0XXg5m+IPkUmwhFrUZUWwbGAGhKwnHoA+YPw3p5ws=";
  };

  subPackages = ".";

  vendorHash = "sha256-shb5m0zWRa9sX0g0WOPpcNMgwpfn8R3c/2GiZGeKr9k=";

  meta = with lib; {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage = "https://github.com/ViRb3/wgcf";
    license = licenses.mit;
    maintainers = with maintainers; [ yureien ];
    mainProgram = "wgcf";
  };
}
