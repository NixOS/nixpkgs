{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wappalyzergo";
  version = "0.2.77";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "wappalyzergo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lU9AhjbM2Ph54aVNyJB+c7CnbovkSIQmGsUa+2SHd14=";
  };

  vendorHash = "sha256-HTh1iNGQXmYe9eNEBhZixr8jyBqWsKhTcUHX4vzItIU=";

  ldflags = [ "-s" ];

  __structuredAttrs = true;

  strictDeps = true;

  meta = {
    description = "Implementation of the Wappalyzer Technology Detection Library";
    homepage = "https://github.com/projectdiscovery/wappalyzergo";
    changelog = "https://github.com/projectdiscovery/wappalyzergo/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wappalyzergo";
  };
})
