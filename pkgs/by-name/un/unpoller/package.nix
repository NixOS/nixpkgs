{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "unpoller";
  version = "2.15.3";

  src = fetchFromGitHub {
    owner = "unpoller";
    repo = "unpoller";
    rev = "v${version}";
    hash = "sha256-MqL+V5NVRE/jzOnj1yFVlT1HPjeiUWsNkJyMetWIaj0=";
  };

  vendorHash = "sha256-w6rU+BV7T8trCd6JBqyXkEgv3qkGTEQpBEq2WsTCo04=";

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
