{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "url-parser";
  version = "2.1.21";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "url-parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4xgfF7tvgqW/xsNacnkySDg8B25sf00xnLDk/PPWgvw=";
  };

  vendorHash = "sha256-RRJldiSjdtVRZBdspf+BmqWmu0i7702Jee30ypdqYNg=";

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
