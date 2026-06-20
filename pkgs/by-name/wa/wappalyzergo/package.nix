{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wappalyzergo";
  version = "0.2.85";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "wappalyzergo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hnNYxeCQcas/FdGBmnpmEbx5NSkVHRZaoGzxoXKc3AU=";
  };

  vendorHash = "sha256-9MUhivdlbxAhcdbLALdt6vhxvMLzm+WincF3iG9pR1A=";

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
