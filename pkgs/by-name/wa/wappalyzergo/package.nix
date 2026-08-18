{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wappalyzergo";
  version = "0.2.94";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "wappalyzergo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hRZ0zITdt87OeN/t0SB1qxaQsW6BSAfjj/YjX/v6IJo=";
  };

  vendorHash = "sha256-KicCQ184+ybGcxTdOjVpgxZ4XzELvVqLyJJXIdiImII=";

  ldflags = [ "-s" ];

  __structuredAttrs = true;

  strictDeps = true;

  meta = {
    description = "Implementation of the Wappalyzer Technology Detection Library";
    homepage = "https://github.com/projectdiscovery/wappalyzergo";
    changelog = "https://github.com/projectdiscovery/wappalyzergo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wappalyzergo";
  };
})
