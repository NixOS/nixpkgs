{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "xsubfind3r";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "hueristiq";
    repo = "xsubfind3r";
    tag = version;
    hash = "sha256-UiOBLvbK3QcmtCn3vySis9rGeAFyRPxxnMze+762hvM=";
  };

  vendorHash = "sha256-ww17mIM0UbEHMU8DnrUtEHQzVUaPNjHO9t+aRpoviII=";

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
