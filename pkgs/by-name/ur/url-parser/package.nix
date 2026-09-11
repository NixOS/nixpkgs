{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "url-parser";
  version = "2.1.25";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "url-parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TpesNTrHpSVZW141C4UbbeVib6wVP0ct+F6+Eil1Sk8=";
  };

  vendorHash = "sha256-gD3TWp5XANdnBMQYnsdV/KlESa7OMihGLOrI/A9BQFs=";

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
