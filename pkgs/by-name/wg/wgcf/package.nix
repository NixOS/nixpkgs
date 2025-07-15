{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wgcf";
  version = "2.2.27";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo = "wgcf";
    tag = "v${version}";
    hash = "sha256-4kzEXJhnE245NnvA0RBsL5oov8sJoiiLZRgw9J06yAc=";
  };

  subPackages = ".";

  vendorHash = "sha256-7wdVyDQCIJ0oSipUJR8CdRaTGQtq//IMDurrpziLFjk=";

  meta = with lib; {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage = "https://github.com/ViRb3/wgcf";
    license = licenses.mit;
    maintainers = with maintainers; [ yureien ];
    mainProgram = "wgcf";
  };
}
