{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "xcrawl3r";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hueristiq";
    repo = "xcrawl3r";
    tag = version;
    hash = "sha256-Ojm5cBeXRtDGQfbDweLlD1V12PYJHxVbO2g1X1Wt/B8=";
  };

  vendorHash = "sha256-rBKpYB7t9zdduqZA1VwCBp+kXpB8nABhTo+IaoOE8bE=";

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
