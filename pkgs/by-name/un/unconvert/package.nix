{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "unconvert";
  version = "0-unstable-2025-02-16";

  src = fetchFromGitHub {
    owner = "mdempsky";
    repo = "unconvert";
    rev = "4a038b3d31f56ff5ba511953b745c80a2317e4ae";
    hash = "sha256-97H5rlb4buRT6I3OUID8/UARFtCTDhIxnPCkpFF9RDs=";
  };

  vendorHash = "sha256-Yh33ZvQoMG9YM8bdxlMYEIwH2QMTwv2HSYSmA4C9EpA=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { extraArgs = lib.singleton "--version=branch"; };

  meta = with lib; {
    description = "Remove unnecessary type conversions from Go source";
    mainProgram = "unconvert";
    homepage = "https://github.com/mdempsky/unconvert";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
  };
}
