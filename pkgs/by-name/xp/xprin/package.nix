{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "xprin";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "crossplane-contrib";
    repo = "xprin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5qRPzrMAW7gw5fv5rgR9hOrZreeWXj/UFyMQAzpCA0s=";
  };

  vendorHash = "sha256-mFICxQ0WHPFxHJ5wmElqcRMOvExKWmX2XXCRQCWbXoI=";

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
