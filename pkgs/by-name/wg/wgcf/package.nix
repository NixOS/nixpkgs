{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wgcf";
  version = "2.2.22";

  src = fetchFromGitHub {
    owner = "ViRb3";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-NzXIzOMc6rVX65FJe/S8rkYJbWNPWRz+mH7vP7Ch9Kw=";
  };

  subPackages = ".";

  vendorHash = "sha256-GinKmXHXWEGmCz83AU3z5JBmPnWJ9Q2EqEPgaTUiDgs=";

  meta = with lib; {
    description = "Cross-platform, unofficial CLI for Cloudflare Warp";
    homepage = "https://github.com/ViRb3/wgcf";
    license = licenses.mit;
    maintainers = with maintainers; [ yureien ];
    mainProgram = "wgcf";
  };
}
