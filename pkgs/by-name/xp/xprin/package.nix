{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "xprin";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "crossplane-contrib";
    repo = "xprin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gxBLdnKYS8pPCAjy0jjv15jM9GN5IWg5/NtFOyRQFsg=";
  };

  vendorHash = "sha256-YBGUB7kAnIMb+T3pB6fd4vOz7C0h0J/EthhIhdnJ/T0=";

  subPackages = [
    "cmd/xprin"
    "cmd/xprin-helpers"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/crossplane-contrib/xprin/internal/version.version=v${finalAttrs.version}"
  ];

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
