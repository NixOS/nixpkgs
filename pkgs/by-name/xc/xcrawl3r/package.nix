{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "xcrawl3r";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "hueristiq";
    repo = "xcrawl3r";
    tag = version;
    hash = "sha256-U5Gu04QR8ZYIUbUwP6k7PfAp1Dz4u2RUVGqamV14BEk=";
  };

  vendorHash = "sha256-GZy7AMhrgswWS4dWRcMW5WF2IVDPeg8ZERizRQi7tZ4=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "CLI utility to recursively crawl webpages";
    homepage = "https://github.com/hueristiq/xcrawl3r";
    changelog = "https://github.com/hueristiq/xcrawl3r/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "xcrawl3r";
  };
}
