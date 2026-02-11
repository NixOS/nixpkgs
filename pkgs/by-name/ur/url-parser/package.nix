{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "url-parser";
  version = "2.1.13";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "url-parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/eu3smf3CeAO+cwhKTL0DB7UVJJ4AJjFjZbNyBbwIZg=";
  };

  vendorHash = "sha256-bcMcooi5dYWs5bIOwSC/rOeb3+FBSFnWjaflTeaA4OU=";

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
