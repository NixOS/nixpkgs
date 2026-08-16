{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tldfinder";
  version = "0.0.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "tldfinder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GUhhZK9jNGRQKDL6PIUmbVwhcFIUSI92YRnx0UcL680=";
  };

  vendorHash = "sha256-lY9AouIIj2OFBRLeaE/8KdF2siiBTuD8ieWdPZVNI9I=";

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for discovering private TLDs";
    homepage = "https://github.com/projectdiscovery/tldfinder";
    changelog = "https://github.com/projectdiscovery/tldfinder/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "tldfinder";
  };
})
