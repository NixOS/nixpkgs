{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wgcf";
  version = "2.2.25";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-XlQ75sjMjwi7gBWHlKyYjfdtBhEw86cSH2bSHVP/qKo=";
  };

  subPackages = ".";

  vendorHash = "sha256-lUC6m8nFXYUD1DJ3ODOCJ31ww0sdv2CDm6K/RAJWdWQ=";

  meta = with lib; {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage = "https://github.com/ViRb3/wgcf";
    license = licenses.mit;
    maintainers = with maintainers; [ yureien ];
    mainProgram = "wgcf";
  };
}
