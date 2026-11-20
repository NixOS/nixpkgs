{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "taproot-assets";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "taproot-assets";
    rev = "v${finalAttrs.version}";
    hash = "sha256-38fuzRJ5USxQ8dnMoF9ktmMyCnwV3fTOs5sU27WqSsk=";
  };

  vendorHash = "sha256-YpxWfNln7YwpKEINbOVbLf1iHEVCRWXj53tC2DhLI6w=";

  subPackages = [
    "cmd/tapcli"
    "cmd/tapd"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Daemon for the Taproot Assets protocol specification";
    homepage = "https://github.com/lightninglabs/taproot-assets";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
  };
})
