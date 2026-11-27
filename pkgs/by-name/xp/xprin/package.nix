{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "xprin";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "crossplane-contrib";
    repo = "xprin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nh9YAtTB+SlACHR/5nHq8uQ0flmsRBScNAktglFlM4c=";
  };

  vendorHash = "sha256-ert+yL6RJKFXkJH3jlIZ5B4biWHjVuBqoPK5yh34c+g=";

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
