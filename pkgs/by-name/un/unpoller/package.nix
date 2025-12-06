{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "unpoller";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "unpoller";
    repo = "unpoller";
    rev = "v${version}";
    hash = "sha256-qnOdJ3QoF6xTjJw2PL+YIFT9kNS4B4/nFX2T0EYIF3w=";
  };

  vendorHash = "sha256-imgSPFU/YhPYXxI7F5C4doM1myWHCEKydytxf37rgsY=";

  ldflags = [
    "-w"
    "-s"
    "-X golift.io/version.Version=${version}"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) unpoller; };

  meta = {
    description = "Collect ALL UniFi Controller, Site, Device & Client Data - Export to InfluxDB or Prometheus";
    homepage = "https://github.com/unpoller/unpoller";
    changelog = "https://github.com/unpoller/unpoller/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Frostman ];
  };
}
