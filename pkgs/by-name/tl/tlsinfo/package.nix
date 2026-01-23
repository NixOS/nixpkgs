{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "tlsinfo";
  version = "0.1.52";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "tlsinfo";
    tag = "v${version}";
    hash = "sha256-ZAK8F6qQo3lAwtal1fh7OVLYC3gjBTeLQPQQjrmfTSM=";
  };

  vendorHash = "sha256-2jO7pd90gD0CWrj18gOwK7vBVKDeWARzvkcutOlmggc=";

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
