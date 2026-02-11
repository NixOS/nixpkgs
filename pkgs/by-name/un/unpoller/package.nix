{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "unpoller";
  version = "2.33.0";

  src = fetchFromGitHub {
    owner = "unpoller";
    repo = "unpoller";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RPhM1oAQhwyNr4CjtxhrhVxw5NfO0lzOq3kx2OqzlwY=";
  };

  vendorHash = "sha256-Z7Wb4nQMPr3og0wWWJp3jU8lTR6hhxMz7XENkanIgQg=";

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
