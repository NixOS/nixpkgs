{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "unpoller";
  version = "5.6.3";

  src = fetchFromGitHub {
    owner = "unpoller";
    repo = "unpoller";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2/cRA/W+5L2l7IcpjagbxBjx+yNulMk4QhQYV9Pv0mU=";
  };

  vendorHash = "sha256-9B6Lhi7jWn5u2Iig3c49ky8kYaNlFiefIVwYdnOEsIo=";

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
