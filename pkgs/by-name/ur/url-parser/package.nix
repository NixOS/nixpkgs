{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "url-parser";
  version = "2.1.12";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "url-parser";
    tag = "v${version}";
    hash = "sha256-LZAOQ1/4tfH1Q4H/YPIoLUnfbRplWqmf5A48qsQpahE=";
  };

  vendorHash = "sha256-dnBZsV9f3V0o2VifEAIK8YxX+VnlRxL35TtaNW2nd4g=";

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
