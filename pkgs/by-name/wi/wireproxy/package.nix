{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  wireproxy,
}:

buildGoModule rec {
  pname = "wireproxy";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "pufferffish";
    repo = "wireproxy";
    rev = "v${version}";
    hash = "sha256-VPIEgvUg0h80Cd611zXQ5mhamfJTQpaDK9kiUMy2G0A=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  vendorHash = "sha256-DNTPzZSxcjkcv7RygTpOIgdYEQ8wBPkuJqfzZGt8ExI=";

  passthru.tests.version = testers.testVersion {
    package = wireproxy;
    command = "wireproxy --version";
    version = src.rev;
  };

  meta = {
    description = "Wireguard client that exposes itself as a socks5 proxy";
    homepage = "https://github.com/pufferffish/wireproxy";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "wireproxy";
  };
}
