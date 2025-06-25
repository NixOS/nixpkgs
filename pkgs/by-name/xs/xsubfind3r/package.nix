{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "xsubfind3r";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hueristiq";
    repo = "xsubfind3r";
    tag = version;
    hash = "sha256-S89X/701BNzT1BJUsGvylBuiuUCf0zpWqp6p6ZHIzyo=";
  };

  vendorHash = "sha256-Jl533DNno0XxjjPvGUVbyYt8fSfHNYKzQwOAmo1IpWw=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "CLI utility to find subdomains from curated passive online sources";
    homepage = "https://github.com/hueristiq/xsubfind3r";
    changelog = "https://github.com/hueristiq/xsubfind3r/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "xsubfind3r";
  };
}
