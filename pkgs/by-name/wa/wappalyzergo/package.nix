{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wappalyzergo";
  version = "0.2.93";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "wappalyzergo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-faf+DiFHyNlZZ0HG7JlgKk8Cb1c8fDqVy/UjQLs7iYw=";
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
