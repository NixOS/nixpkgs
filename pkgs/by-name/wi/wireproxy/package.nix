{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  wireproxy,
}:

buildGoModule (finalAttrs: {
  pname = "wireproxy";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "windtf";
    repo = "wireproxy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TnwkBkLMYc8TLvgDnzNSKvJy1MBXtjeVo+nY8ePf/T4=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  vendorHash = "sha256-3X/0JHT0f6C7nlhD6Bh0hxyDcPZ3xqf6+wxa5VygXgo=";

  passthru.tests.version = testers.testVersion {
    package = wireproxy;
    command = "wireproxy --version";
    version = finalAttrs.src.rev;
  };

  meta = {
    description = "Wireguard client that exposes itself as a socks5 proxy";
    homepage = "https://github.com/windtf/wireproxy";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "wireproxy";
  };
})
