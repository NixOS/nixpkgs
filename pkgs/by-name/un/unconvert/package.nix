{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "unconvert";
  version = "0-unstable-2026-10-20";

  src = fetchFromGitHub {
    owner = "mdempsky";
    repo = "unconvert";
    rev = "975dd2843474121025ccaa28c69ff5a77befacbc";
    hash = "sha256-dJs36U1H1N4Pm0vQQwn/jAM6UfqB1dPcU+DgPBChfBM=";
  };

  vendorHash = "sha256-lAmmhM+cmZzyL18UL66Jq2GpFJJ/F97B7/jxhKmdjDE=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { extraArgs = lib.singleton "--version=branch"; };

  meta = {
    description = "Remove unnecessary type conversions from Go source";
    mainProgram = "unconvert";
    homepage = "https://github.com/mdempsky/unconvert";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kalbasit ];
  };
}
