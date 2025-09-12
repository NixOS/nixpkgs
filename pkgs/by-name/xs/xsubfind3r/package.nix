{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "xsubfind3r";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "hueristiq";
    repo = "xsubfind3r";
    tag = version;
    hash = "sha256-whe7GXstGj2Yh/UtpNAh71WwnRU9aEHtS0diW0m9QXs=";
  };

  vendorHash = "sha256-cYutO+N974ZJE/UJiYS0ZuWqRKlfDgEL5qqsejBptcs=";

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
