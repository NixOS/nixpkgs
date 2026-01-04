{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "unpoller";
  version = "2.21.0";

  src = fetchFromGitHub {
    owner = "unpoller";
    repo = "unpoller";
    rev = "v${version}";
    hash = "sha256-Me2A6ir4B/isGOIS5aucOJrITMzCUSWFjHg7bXZXR8U=";
  };

  vendorHash = "sha256-6b5HWBDNJWj02+uGq5r1Foxo3bX7gf9/kbAw/SL3Jvw=";

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
