{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "url-parser";
  version = "2.1.16";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "url-parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y3tbEpAp3kTjkAuB0gjRPD+gWskTzOKdB4/rilHbyxU=";
  };

  vendorHash = "sha256-smSFWfuQ3wq/ZfDwUBIUdb4DBu9TPKtJ5Ttys5xFAsE=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.BuildVersion=${finalAttrs.version}"
    "-X"
    "main.BuildDate=1970-01-01"
  ];

  meta = {
    description = "Simple command-line URL parser";
    homepage = "https://github.com/thegeeklab/url-parser";
    changelog = "https://github.com/thegeeklab/url-parser/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "url-parser";
  };
})
