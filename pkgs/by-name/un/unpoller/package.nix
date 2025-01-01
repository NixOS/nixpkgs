{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "unpoller";
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "unpoller";
    repo = "unpoller";
    rev = "v${version}";
    hash = "sha256-/X2hCtF38X0twHsHSjpf23Mdz9aK43z3jhWbfkUo0kQ=";
  };

  vendorHash = "sha256-d7kkdiGMT3bN1dfNo8m+zp3VY8kaZM2BWO3B3iAdUQY=";

  ldflags = [
    "-w"
    "-s"
    "-X github.com/prometheus/common/version.Branch=master"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
    "-X github.com/prometheus/common/version.Revision=${src.rev}"
    "-X github.com/prometheus/common/version.Version=${version}-0"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) unpoller; };

  meta = with lib; {
    description = "Collect ALL UniFi Controller, Site, Device & Client Data - Export to InfluxDB or Prometheus";
    homepage = "https://github.com/unpoller/unpoller";
    changelog = "https://github.com/unpoller/unpoller/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Frostman ];
  };
}
