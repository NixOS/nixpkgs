{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "uniex";
  version = "0.1.32";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "uniex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L1H23SHrYyEPqgPFHRapZKB9nW/vRwAw3ZopteBbeW8=";
  };

  vendorHash = "sha256-HKOHrrwhqgwlXIMMP/4IDcGrFXLAnrzVFwidK+3/5wQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/paepckehh/uniex/releases/tag/v${finalAttrs.version}";
    homepage = "https://paepcke.de/uniex";
    description = "Unifi controller device inventory exporter, analyses all device and stat records for complete records";
    license = lib.licenses.bsd3;
    mainProgram = "uniex";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})
