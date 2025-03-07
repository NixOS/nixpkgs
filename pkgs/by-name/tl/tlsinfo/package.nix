{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tlsinfo";
  version = "0.1.43";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "tlsinfo";
    tag = "v${version}";
    hash = "sha256-3H/1UlktRVnCd95OFkOqPp6gciGZCOBpj0UFfO+tyJg=";
  };

  vendorHash = "sha256-yFb4Z8i3b6lPQ4NOszEI2k5s5dmE7Z7YGSFZuExXZ4I=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    changelog = "https://github.com/paepckehh/tlsinfo/releases/tag/v${version}";
    homepage = "https://paepcke.de/tlsinfo";
    description = "Tool to analyze and troubleshoot TLS connections";
    license = lib.licenses.bsd3;
    mainProgram = "tlsinfo";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}
