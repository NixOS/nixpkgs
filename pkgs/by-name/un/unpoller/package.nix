{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "unpoller";
  version = "5.9.5";

  src = fetchFromGitHub {
    owner = "unpoller";
    repo = "unpoller";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nVvQ/ef5KaTkK8DirN17CfsMAv5bzQ1Z/47ti69CdW4=";
  };

  vendorHash = "sha256-GSonMKzdNY+jbu6WUbUELfCpp7q9PbTyY4onsInrzoM=";

  ldflags = [
    "-w"
    "-s"
    "-X golift.io/version.Version=${finalAttrs.version}"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) unpoller; };

  meta = {
    description = "Collect ALL UniFi Controller, Site, Device & Client Data - Export to InfluxDB or Prometheus";
    homepage = "https://github.com/unpoller/unpoller";
    changelog = "https://github.com/unpoller/unpoller/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Frostman ];
  };
})
