{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "taproot-assets";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "taproot-assets";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rLr/nPnmB2DJsCuQLdBTN0H4rJwTuQ1KDM2VriBKgEI=";
  };

  vendorHash = "sha256-X3uKIEEDGx2ut73yXlCVFQYz7jItEFSZITr9wF+D/qA=";

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
