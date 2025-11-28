{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "taproot-assets";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "taproot-assets";
    rev = "v${version}";
    hash = "sha256-z4lNeVmy0AEDM8ivdfXfXqi/V1LIDHV2KtS5/19+Jlk=";
  };

  vendorHash = "sha256-p75eZoM6tSayrxcKTCoXR8Jlc3y2UyzfPCtRJmDy9ew=";

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
