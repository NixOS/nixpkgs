{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "taproot-assets";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "taproot-assets";
    rev = "v${version}";
    hash = "sha256-aQYVPSDudLK4ZBcBN/wNjVoF/9inOaJRbcyTP6VMdA0=";
  };

  vendorHash = "sha256-IFzYW5vAtBoUC2ebFYnxS/TojQR4kXxQACNbyn2ZkCs=";

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
