{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "tfsort";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "AlexNabokikh";
    repo = "tfsort";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nUIT/xkqkE3Y5aswhaeEZamH4rQ9V/iAhkZHEipEV68=";
  };

  vendorHash = "sha256-0+oHc2R9C7XEXgpH4VqtMgdOcI8yU6L5hF77PrEkDi4=";

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
