{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "taproot-assets";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "taproot-assets";
    rev = "v${version}";
    hash = "sha256-ZLuV52W5WTNp45tnF1mmf+Snjd14604cKpnOjhabuoc=";
  };

  vendorHash = "sha256-9Du4WHLltGqmJXDOs2t5dwK5dbFGxWn0EiEE47czW2M=";

  subPackages = [
    "cmd/tapcli"
    "cmd/tapd"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Daemon for the Taproot Assets protocol specification";
    homepage = "https://github.com/lightninglabs/taproot-assets";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
