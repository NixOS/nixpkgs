{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "xcrawl3r";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "hueristiq";
    repo = "xcrawl3r";
    rev = "refs/tags/${version}";
    hash = "sha256-W1cvSvRnDGFp4br8s/nL+owIGWTJ1bVX6kvmeTLUuuI=";
  };

  vendorHash = "sha256-fHdtqjFmT+8cmy2SxjjBvw5Rct7lA2ksGVmm/9ncbRI=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "CLI utility to recursively crawl webpages";
    homepage = "https://github.com/hueristiq/xcrawl3r";
    changelog = "https://github.com/hueristiq/xcrawl3r/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "xcrawl3r";
  };
}
