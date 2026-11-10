{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wappalyzergo";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "wappalyzergo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qgSZKd6vrh92n8/2XZDI9Cl9Jiw/bAAwGMBzEo+nYa0=";
  };

  vendorHash = "sha256-96se+0ZLIcX5o3TrMMCospbX7WIafxGskMKEQW791Bo=";

  ldflags = [ "-s" ];

  __structuredAttrs = true;

  meta = {
    description = "Implementation of the Wappalyzer Technology Detection Library";
    homepage = "https://github.com/projectdiscovery/wappalyzergo";
    changelog = "https://github.com/projectdiscovery/wappalyzergo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wappalyzergo";
  };
})
