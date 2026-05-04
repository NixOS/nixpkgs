{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  wireproxy,
}:

buildGoModule (finalAttrs: {
  pname = "wireproxy";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "pufferffish";
    repo = "wireproxy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-R1G/VtyQsl7yoDwZw+24qTdeq//qYQTQwzAPvH8f+ls=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  vendorHash = "sha256-T6RN7f05bNVL7gfhaAR0+lKZWqXvMcgjiyPldCmmvU4=";

  passthru.tests.version = testers.testVersion {
    package = wireproxy;
    command = "wireproxy --version";
    version = finalAttrs.src.rev;
  };

  meta = {
    description = "Wireguard client that exposes itself as a socks5 proxy";
    homepage = "https://github.com/pufferffish/wireproxy";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "wireproxy";
  };
})
