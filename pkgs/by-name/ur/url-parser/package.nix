{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "url-parser";
  version = "2.1.10";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "url-parser";
    tag = "v${version}";
    hash = "sha256-5QpcioReUAO11QOLbU+KtUd4Zs+hi/lvNvEzDpDQbhU=";
  };

  vendorHash = "sha256-3TOUdwBq6TgzZIDtaoIoi2ur83DmAjBfi1ILJIGpyJU=";

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
