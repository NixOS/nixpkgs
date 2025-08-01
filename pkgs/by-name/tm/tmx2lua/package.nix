{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tmx2lua";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "hawkthorne";
    repo = "tmx2lua";
    tag = "v${version}";
    hash = "sha256-vORmsr1hcdPzZYZZJ9GTOJ5B/fT2sp47Kc1dzbgDW9M=";
  };

  vendorHash = "sha256-Vfr5/lhpb+Qdhi4Z/yCbUUyd5DvI3z8UfUfxx+975iQ=";

  meta = {
    description = "Convert TMX files to Lua for LÖVE";
    homepage = "https://github.com/hawkthorne/tmx2lua";
    changelog = "https://github.com/hawkthorne/tmx2lua/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "tmx2lua";
  };
}
