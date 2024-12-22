{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tlsinfo";
  version = "0.1.41";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "tlsinfo";
    rev = "refs/tags/v${version}";
    hash = "sha256-II5/UDWVeEoupM1Ijty2A9M/qwWA2/b4Y68lTkxnJ9o=";
  };

  vendorHash = "sha256-IyinAjgK4vm+TkSGQq+XnY9BESsNvXgz84BRzNyZtJY=";

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
