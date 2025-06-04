{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  wireproxy,
}:

buildGoModule rec {
  pname = "wireproxy";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "pufferffish";
    repo = "wireproxy";
    rev = "v${version}";
    hash = "sha256-F8WatQsXgq3ex2uAy8eoS2DkG7uClNwZ74eG/mJN83o=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  vendorHash = "sha256-uCU5WLCKl5T4I1OccVl7WU0GM/t4RyAEmzHkJ22py30=";

  passthru.tests.version = testers.testVersion {
    package = wireproxy;
    command = "wireproxy --version";
    version = src.rev;
  };

  meta = with lib; {
    description = "Wireguard client that exposes itself as a socks5 proxy";
    homepage = "https://github.com/pufferffish/wireproxy";
    license = licenses.isc;
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "wireproxy";
  };
}
