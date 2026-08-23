{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "unpoller";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "unpoller";
    repo = "unpoller";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VLGURSaFCtGYHEq9wZt7dOCxOS/EqHizw9dmutYWIuQ=";
  };

  vendorHash = "sha256-Im99hlpLDDIbxVusNgaNDKwN/axyPrd0nHj486qR94k=";

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
