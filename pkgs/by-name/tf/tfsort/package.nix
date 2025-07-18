{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "tfsort";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "AlexNabokikh";
    repo = "tfsort";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4LB4A1zvurhaV18BqT3m6ltJJz/ny0Fd+a52pEREBSQ=";
  };

  vendorHash = "sha256-SebYucVQTbIr3kCaCVejw3FEaw9wi2fBVT55yuZRn48=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
    "-X main.commit=${finalAttrs.version}"
    "-X main.date=1970-01-01"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/AlexNabokikh/tfsort/releases/tag/v${finalAttrs.version}";
    description = "Utility to sort Terraform variables, outputs, locals and terraform blocks";
    homepage = "https://github.com/AlexNabokikh/tfsort";
    license = lib.licenses.asl20;
    mainProgram = "tfsort";
    maintainers = [
      lib.maintainers.alexnabokikh
    ];
  };
})
