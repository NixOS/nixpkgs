{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "tfsort";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "AlexNabokikh";
    repo = "tfsort";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UlI1/xcj/xlAgZPiqI9FiJL7JqjP/J00xQZvzXktbxc=";
  };

  vendorHash = "sha256-H3sdwIKJcOfExYKRafLaBMTyUArc7jTpoW5zynJLtAY=";

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
