{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "ziti";
  version = "1.6.9";

  src = fetchFromGitHub {
    owner = "openziti";
    repo = "ziti";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Thk0h67qUL72xewbpjujv7mUYzpSAWJXMk6QmPFGqVg=";
  };

  vendorHash = "sha256-qHC9MqQ0SGTzt+WP+30UIe/lMk10DBYRjya5ZPiQblU=";

  subPackages = [
    "ziti"
    "controller"
    "router"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/openziti/ziti/common/version.Version=v${finalAttrs.version}"
    "-X github.com/openziti/ziti/common/version.Revision=v${finalAttrs.version}"
  ];

  meta = {
    description = "CLI for working with a Ziti deployment";
    changelog = "https://github.com/openziti/ziti/releases/tag/v${finalAttrs.version}";
    homepage = "https://openziti.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jamalhabash
      andrewzah
    ];
    mainProgram = "ziti";
  };
})
