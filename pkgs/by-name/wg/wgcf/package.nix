{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wgcf";
  version = "2.2.29";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo = "wgcf";
    tag = "v${version}";
    hash = "sha256-Ak6EG24U9goQb1tOLRXI5kQen24c4KlDVDKhuTfobbo=";
  };

  subPackages = ".";

  vendorHash = "sha256-lG0D0LJV9IMq9R8O4IuxTQeulBb4q0ToZTU+HaGmn68=";

  meta = with lib; {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage = "https://github.com/ViRb3/wgcf";
    license = licenses.mit;
    maintainers = with maintainers; [ yureien ];
    mainProgram = "wgcf";
  };
}
