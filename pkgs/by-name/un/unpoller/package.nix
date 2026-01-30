{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "unpoller";
  version = "2.23.0";

  src = fetchFromGitHub {
    owner = "unpoller";
    repo = "unpoller";
    rev = "v${version}";
    hash = "sha256-pbihZS+Jq+YLMFvYxK2usCrzYWTuMbAGOyDkkWPxT9Q=";
  };

  vendorHash = "sha256-r/j66dXi2xsFmAHNieuUuRNX2bosVdnrjcXnmr8c/3M=";

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
