{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "yaml-schema-router";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "traiproject";
    repo = "yaml-schema-router";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GFe5NPW8nxv+bQsG5G26WCf2Z6qrW1WAZBMWFZD8MFI=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Content-based JSON schema routing for yaml-language-server";
    homepage = "https://github.com/traiproject/yaml-schema-router";
    changelog = "https://github.com/traiproject/yaml-schema-router/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "yaml-schema-router";
  };
})
