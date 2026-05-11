{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wappalyzergo";
  version = "0.2.79";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "wappalyzergo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KPr6TvnwY+fd0xQHbVrjCVQuEx2ukJu+FPeonkyD/Q8=";
  };

  vendorHash = "sha256-HTh1iNGQXmYe9eNEBhZixr8jyBqWsKhTcUHX4vzItIU=";

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
