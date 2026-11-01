{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "unpoller";
  version = "5.9.0";

  src = fetchFromGitHub {
    owner = "unpoller";
    repo = "unpoller";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7bhdBHtMqC1DETio/yU41jFQkP+nys4ODJLlVykGcG8=";
  };

  vendorHash = "sha256-Ls+RCCixnrZJ5iEmDA6thOmTcvGKmHaZso8ZKrCSpGE=";

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
