{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "taproot-assets";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "taproot-assets";
    rev = "v${version}";
    hash = "sha256-XOEbrz0kFJKoYG91VUeSAuMVJRfGRNTQ8jucMtnvxJo=";
  };

  vendorHash = "sha256-hDmRyWSf4jokomfJQBLlIbm9I3v2/sg/xD52BW3Wvy4=";

  subPackages = [
    "cmd/tapcli"
    "cmd/tapd"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Daemon for the Taro protocol specification";
    homepage = "https://github.com/lightninglabs/taro";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
