{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tproxy";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "kevwan";
    repo = "tproxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rVcPI0cB1TMiG4swdflOwFq+W23suM97qqPs6T4vmqw=";
  };

  vendorHash = "sha256-ygaRcSIYNesA1zWdUlL0AqSxec4dwIE0cbGImHX7+wU=";

  ldflags = [
    "-w"
    "-s"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool to proxy and analyze TCP connections";
    homepage = "https://github.com/kevwan/tproxy";
    changelog = "https://github.com/kevwan/tproxy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DCsunset ];
    mainProgram = "tproxy";
  };
})
