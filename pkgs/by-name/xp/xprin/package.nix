{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "xprin";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "crossplane-contrib";
    repo = "xprin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ncqmrp2jF4fUjE9bEOgfq6XuAghvK4y3j2KOqXxLzrU=";
  };

  vendorHash = "sha256-8trj5T6ShvHXFB3W8F++ton71F8XDn2kyoZPIdPmEyo=";

  subPackages = [
    "cmd/xprin"
    "cmd/xprin-helpers"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/crossplane-contrib/xprin/internal/version.version=v${finalAttrs.version}"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Crossplane testing framework for render and schema validation";
    homepage = "https://github.com/crossplane-contrib/xprin";
    changelog = "https://github.com/crossplane-contrib/xprin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      LorenzBischof
    ];
    mainProgram = "xprin";
  };
})
