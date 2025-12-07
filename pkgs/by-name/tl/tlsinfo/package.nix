{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "tlsinfo";
  version = "0.1.51";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "tlsinfo";
    tag = "v${version}";
    hash = "sha256-UD/dy8pEulsoNOC5W+hkC+n4y8SjpZ0QOOECGPVy1ws=";
  };

  vendorHash = "sha256-SkCuyYUwVcbCDSN0NtX29BNP/pPlFHqo0jU0Qo02mNk=";

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
