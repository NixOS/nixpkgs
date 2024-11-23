{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "txtpbfmt";
  version = "0-unstable-2024-06-11";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "txtpbfmt";
    rev = "dedd929c1c222fd4d895cda0e1c87b940262b1f5";
    hash = "sha256-L9btIjcQ3XMPzUrizoSEJ/Zj2xWphFAka3qtzm2mxP4=";
  };

  vendorHash = "sha256-IdD+R8plU4/e9fQaGSM5hJxyMECb6hED0Qg8afwHKbY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Formatter for text proto files";
    homepage = "https://github.com/protocolbuffers/txtpbfmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "txtpbfmt";
  };
}
