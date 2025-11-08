{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "tlsinfo";
  version = "0.1.50";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "tlsinfo";
    tag = "v${version}";
    hash = "sha256-EtKke+kMheZ7R7q+4TlJD18x+s5qTa+JFpdwFdDsa7A=";
  };

  vendorHash = "sha256-L5xL66T2FDTjiGb4VrCjwalcvKzCYdGaJ/w77FyEZjo=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/paepckehh/tlsinfo/releases/tag/v${version}";
    homepage = "https://paepcke.de/tlsinfo";
    description = "Tool to analyze and troubleshoot TLS connections";
    license = lib.licenses.bsd3;
    mainProgram = "tlsinfo";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}
