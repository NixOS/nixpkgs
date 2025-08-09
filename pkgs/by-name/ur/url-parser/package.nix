{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "url-parser";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "url-parser";
    tag = "v${version}";
    hash = "sha256-pxpeqZfvNZbX+Eh4Jh1SRo0ymvZokeEQRotW7XV3Udo=";
  };

  vendorHash = "sha256-GhBSVbzZ3UqFroLimi5VbTVO6DhEMVAd6iyhGwO6HK0=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.BuildVersion=${version}"
    "-X"
    "main.BuildDate=1970-01-01"
  ];

  meta = {
    description = "Simple command-line URL parser";
    homepage = "https://github.com/thegeeklab/url-parser";
    changelog = "https://github.com/thegeeklab/url-parser/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "url-parser";
  };
}
